// import classNames from "classnames";
// import React from "react";
// import { StyleSheet, Text, TouchableOpacity } from "react-native";

// export enum ButtonType {
//   TEXT,
//   PRIMARY,
//   SECONDARY,
// }

// type ButtonProps = {
//   title: string;
//   buttonType: ButtonType;
//   onClick: VoidFunction;
// };

// export const Button: React.FC<ButtonProps> = ({
//   title,
//   buttonType,
//   onClick,
// }) => {
//   const buttonStyle = [
//     styles.baseButton,
//     buttonType === ButtonType.PRIMARY && styles.primaryButton,
//     buttonType === ButtonType.SECONDARY && styles.secondaryButton,
//     buttonType === ButtonType.TEXT && styles.textButton,
//   ];

//   const textStyle = [
//     styles.baseText,
//     buttonType === ButtonType.PRIMARY && styles.primaryText,
//     buttonType === ButtonType.SECONDARY && styles.secondaryText,
//     buttonType === ButtonType.TEXT && styles.textButtonText,
//   ];

//   return (
//     <TouchableOpacity style={buttonStyle} onPress={onClick}>
//       <Text className="text-blue-950">{title}</Text>
//     </TouchableOpacity>
//   );
// };

// const styles = StyleSheet.create({
//   baseButton: {
//     paddingHorizontal: 16,
//     paddingVertical: 8,
//     borderRadius: 6,
//   },
//   primaryButton: {
//     backgroundColor: "#3B82F6", // blue-500
//   },
//   secondaryButton: {
//     backgroundColor: "#6B7280", // gray-500
//   },
//   textButton: {
//     backgroundColor: "transparent",
//   },
//   baseText: {
//     fontSize: 16,
//   },
//   primaryText: {
//     color: "#FFFFFF",
//   },
//   secondaryText: {
//     color: "#FFFFFF",
//   },
//   textButtonText: {
//     color: "#3B82F6", // blue-500
//   },
// });
