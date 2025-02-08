import React from "react";

type Props = {
  errorMessage?: string;
} & React.ComponentProps<"input">;

export const Input = React.forwardRef<HTMLInputElement, Props>(
  ({ errorMessage, ...props }, ref) => (
    <>
      <input className="form-control" ref={ref} {...props} />
      {errorMessage ? (
        <div className="text-danger">{errorMessage}</div>
      ) : null}{" "}
    </>
  )
);

Input.displayName = "Input";
