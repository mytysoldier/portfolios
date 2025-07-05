import React from "react";
import "./App.css";
import { DispWithoutErrorBoundary } from "./DispWithoutErrorBoundary.tsx";
import { ErrorBoundary } from "react-error-boundary";
import { DispWithErrorBoundary } from "./DispWithErrorBoundary.tsx";

function App() {
  return (
    <div>
      {/* <header className="App-header">
        <p>
          Edit <code>src/App.tsx</code> and save to reload.
        </p>
        <a
          className="App-link"
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </a>
      </header> */}
      {/* <DispWithoutErrorBoundary /> */}
      <ErrorBoundary FallbackComponent={<div>エラーが発生しました。</div>}>
        <DispWithErrorBoundary />
      </ErrorBoundary>
    </div>
  );
}

export default App;
