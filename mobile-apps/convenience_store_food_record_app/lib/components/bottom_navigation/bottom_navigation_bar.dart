// import 'package:flutter/material.dart';

// class BottomNavigationBar extends StatefulWidget {
//   const BottomNavigationBar({super.key});

//   @override
//   State<StatefulWidget> createState() => _BottomNavigationBarState();
// }

// class _BottomNavigationBarState extends State<BottomNavigationBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
//         BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Record'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.bar_chart),
//           label: 'Statistics',
//         ),
//       ],
//       currentIndex: _selectedIndex,
//       onTap: _onItemTapped,
//     );
//   }
// }
