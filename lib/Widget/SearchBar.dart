import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final void Function(String input) search;

  SearchBar({required this.search});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();
  bool state = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: const Offset(0, 2),
                blurRadius: 5,
                spreadRadius: .3,
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: !state ? const EdgeInsets.only(left: 10) : null,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: "Search",
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (value)
                    {
                      setState(() {
                        widget.search(_controller.text);
                      });
                    },
                  ),
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    FocusScope.of(context).unfocus();
                    widget.search(_controller.text);
                  });
                },
                icon: const Icon(Icons.search))
          ],
        ),
      ),
    );
  }
}
