import React, { useState, useEffect } from "react";
import { ErrorBoundary } from "react-error-boundary";

export function DispWithErrorBoundary() {
  const [isRendering, setIsRendering] = useState(true);
  const [hasError, setHasError] = useState(false);
  const [, setState] = useState();

  // useEffect(() => {
  //   const timer = setTimeout(() => {
  //     // エラーを発生させる
  //     throwError();
  //     setIsRendering(false);
  //   }, 2000);

  //   return () => clearTimeout(timer);
  // }, []);

  useEffect(() => {
    const timer = setTimeout(() => {
      // エラーを発生させる
      try {
        throwError();
      } catch (error) {
        // setHasError(true);
        setState(() => {
          throw error;
        });
      }
      // throwError();
      // setIsRendering(false);
    }, 2000);

    return () => clearTimeout(timer);
  }, []);

  const throwError = () => {
    throw new Error("An error has occurred.");
  };

  if (isRendering) {
    return <div>処理中...</div>;
  }
  return <div>Component has been rendered successfully.</div>;
}
