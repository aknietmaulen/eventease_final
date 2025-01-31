
import 'package:eventease_final/my_theme.dart';
import 'package:flutter/material.dart';

class CustomSearchContainer extends StatelessWidget {
  final Function(String) onSearch;

  const CustomSearchContainer({
    super.key,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image(
          image: AssetImage('assets/icons/ic_search.png'),
        ),
        Container(
          color: MyTheme.white.withOpacity(0.6),
          width: 1,
          height: 20,
          margin: EdgeInsets.symmetric(horizontal: 4),
        ),
        Expanded(
          child: TextField(
            onChanged: onSearch, // Notify when the input changes
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(
                color: MyTheme.white.withOpacity(0.6),
                fontSize: 18,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: MyTheme.customLightPurple.withOpacity(1),
              borderRadius: BorderRadius.all(Radius.circular(20))),
        )
      ],
    );
  }
}
