import React from "react";

type ButtonProps = {
  label: string;
  onClick: VoidFunction;
};

export const Button: React.FC<ButtonProps> = ({ label, onClick }) => (
  <button onClick={onClick}>{label}</button>
);
