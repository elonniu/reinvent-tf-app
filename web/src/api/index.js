// import { Toast } from "antd-mobile";
const API_URL =
  process.env.REACT_APP_API_URL || "https://b3ollyppvg.execute-api.ap-northeast-1.amazonaws.com";

export const fetcher = async ({ path, method = "GET", params, postData }, args) => {
  const { params: argParams, body } = args?.arg || {};
  const opt = {
    method: method,
    headers: {
      "Content-Type": "application/json",
    },
  };

  const pathHasQuery = path && path.includes("?");
  let query = "";

  const allParams = {
    ...params,
    ...argParams,
  };

  if (allParams) {
    Object.entries(allParams).forEach(([key, value], index) => {
      if (index === 0 && !pathHasQuery) {
        query += `?${key}=${value}`;
      } else {
        query += `&${key}=${value}`;
      }
    });
  }

  if (method !== "GET") {
    opt.body = JSON.stringify({
      ...postData,
      ...body,
    });
  }

  const res = await fetch(path.startsWith("https") ? path : `${API_URL}${path}${query}`, opt);

  // 如果状态码不在 200-299 的范围内，
  // 我们仍然尝试解析并抛出它。
  if (!res.ok) {
    // 将额外的信息附加到错误对象上。
    const error = {};
    error.info = await res.json();
    error.status = "error";

    // Unauthorized
    if (error.info.message) {
      // Toast.show({
      //   content: error.info.message,
      //   afterClose: () => {
      //     console.log("after");
      //   },
      // });
    }

    return error;
  }

  const data = await res.json();

  return data.body ? data.body : data;
};

export const fetcherPost = async ({ path, fetchBody = {} }, args) => {
  const { query, body } = args.arg || {};
  if (query) {
    Object.entries(query).forEach(([key, value], index) => {
      path += `${index === 0 ? "?" : "&"}${key}=${value}`;
    });
  }
  return fetcher({ path, method: "POST", postData: { ...fetchBody, ...body } || {} });
};

export const fetcherPut = async ({ path }, args) => {
  const { query, body } = args.arg;
  if (query) {
    Object.entries(query).forEach(([key, value], index) => {
      path += `${index === 0 ? "?" : "&"}${key}=${value}`;
    });
  }
  return fetcher({ path, method: "PUT", postData: body || {} });
};

export const fetcherDelete = async ({ path }, args) => {
  const { query, body, path: pathData } = args.arg;
  Object.entries(pathData || {}).forEach(([k, v]) => {
    path = path.replace(k, v);
  });
  if (query) {
    Object.entries(query).forEach(([key, value], index) => {
      path += `${index === 0 ? "?" : "&"}${key}=${value}`;
    });
  }
  return fetcher({ path, method: "DELETE", postData: body || {} });
};
