import "./App.scss";
import useSWRMutation from "swr/mutation";
import { fetcher } from "./api";
import { useEffect, useState } from "react";
import Input from "@cloudscape-design/components/input";
import { SpaceBetween } from "@cloudscape-design/components";
import Checkbox from "@cloudscape-design/components/checkbox";
import Button from "@cloudscape-design/components/button";
import FormField from "@cloudscape-design/components/form-field";
import Spinner from "@cloudscape-design/components/spinner";

function App() {
  const [rotate, setRotate] = useState(0);
  const [convert, setConvert] = useState(false);
  const { data, isMutating, trigger } = useSWRMutation(
    {
      path: "/prod/image?key=dog.jpeg&bucket=elonniu",
      params: {
        rotate,
        convert,
      },
    },
    fetcher
  );

  useEffect(() => {
    trigger();
  }, []);

  console.log(30, isMutating);

  return (
    <div className="App">
      <div className="image-warp">
        <img src={data?.presigned_url} />
        {isMutating && (
          <div className="spinner">
            <Spinner size="large"></Spinner>
          </div>
        )}
      </div>
      <div className="footer">
        <div className="footer-container">
          <div className="input">
            <FormField label="Rotate">
              <Input
                type="number"
                onChange={({ detail }) => setRotate(detail.value)}
                value={rotate}
              />
            </FormField>
          </div>
          <div className="input check">
            <FormField label="Convert">
              <Checkbox onChange={({ detail }) => setConvert(detail.checked)} checked={convert}>
                {convert ? "YES" : "NO"}
              </Checkbox>
            </FormField>
          </div>
          <div className="btn">
            <Button variant="primary" loading={isMutating} onClick={() => trigger()}>
              Refresh
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
