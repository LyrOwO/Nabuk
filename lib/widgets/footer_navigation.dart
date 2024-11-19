import 'package:flutter/material.dart';

class FooterNavigation extends StatelessWidget {
  final int currentIndex;

  const FooterNavigation({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 0) Navigator.pushNamed(context, '/');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.book,
              color: currentIndex == 1 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 1) Navigator.pushNamed(context, '/books');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.storage,
              color: currentIndex == 2 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 2) Navigator.pushNamed(context, '/shelves');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: currentIndex == 3 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 3) Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person,
              color: currentIndex == 4 ? Color.fromRGBO(211, 180, 156, 50) : Colors.grey,
            ),
            onPressed: () {
              if (currentIndex != 4) Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    );
  }
}
