import React, { useState, useEffect } from "react";

export function DispWithoutErrorBoundary() {
  const [isRendering, setIsRendering] = useState(true);
  const [hasError, setHasError] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      try {
        throwError();
      } catch (error) {
        console.error(error);
        setHasError(true);
      } finally {
        setIsRendering(false);
      }
      setIsRendering(false);
    }, 2000);

    return () => clearTimeout(timer);
  }, []);

  const throwError = () => {
    throw new Error("An error has occurred.");
  };

  if (isRendering) {
    return <div>処理中...</div>;
  } else {
    if (hasError) {
      return <div>エラーが発生しました。</div>;
    }
    return <div>Component has been rendered successfully.</div>;
  }
}
