import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';

class GFAccordion extends StatefulWidget {
  const GFAccordion(
      {Key key,
      this.child,
      this.content,
      this.collapsedTitlebackgroundColor =  Colors.white,
        this.expandedTitlebackgroundColor= const Color(0xFFE0E0E0),
      this.collapsedIcon = const Icon(Icons.keyboard_arrow_down),
      this.expandedIcon = const Icon(Icons.keyboard_arrow_up),
      this.title,
      this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
      this.titlePadding = const EdgeInsets.all(10),
      this.contentbackgroundColor,
      this.contentPadding = const EdgeInsets.all(10),
      this.contentChild,
      this.titleborderColor = const Border(),
      this.contentBorderColor = const Border(),
      this.margin})
      : super(key: key);

  /// child of  type [Widget]is alternative to title key. title will get priority over child
  final Widget child;

  /// content of type[String] which shows the messages after the [GFAccordion] is expanded
  final String content;

  /// contentChild of  type [Widget]is alternative to content key. content will get priority over contentChild
  final Widget contentChild;

  /// type of [Color] or [GFColor] which is used to change the background color of the [GFAccordion] title when it is collapsed
  final dynamic collapsedTitlebackgroundColor;

  /// type of [Color] or [GFColor] which is used to change the background color of the [GFAccordion] title when it is expanded
  final dynamic expandedTitlebackgroundColor;

  ///collapsedIcon of type [Widget] which is used to show when the [GFAccordion] is collapsed
  final Widget collapsedIcon;

  ///expandedIcon of type[Widget] which is used when the [GFAccordion] is expanded
  final Widget expandedIcon;

  /// text of type [String] is alternative to child. text will get priority over child
  final String title;

  /// textStyle of type [textStyle] will be applicable to text only and not for the child
  final TextStyle textStyle;

  ///titlePadding of type [EdgeInsets] which is used to set the padding of the [GFAccordion] title
  final EdgeInsets titlePadding;

  ///descriptionPadding of type [EdgeInsets] which is used to set the padding of the [GFAccordion] description
  final EdgeInsets contentPadding;

  /// type of [Color] or [GFColor] which is used to change the background color of the [GFAccordion] description
  final dynamic contentbackgroundColor;

  ///margin of type [EdgeInsets] which is used to set the margin of the [GFAccordion]
  final EdgeInsets margin;

  ///titleborderColor of type  [Color] or [GFColor] which is used to change the border color of title
  final dynamic titleborderColor;

  ///contentBorderColor of type  [Color] or [GFColor] which is used to change the border color of content
  final dynamic contentBorderColor;

  @override
  _GFAccordionState createState() => _GFAccordionState();
}

class _GFAccordionState extends State<GFAccordion>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    offset = Tween(begin: Offset(0.0, -0.06), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  bool showAccordion = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin != null ? widget.margin : EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                switch (controller.status) {
                  case AnimationStatus.completed:
                    controller.forward(from: 0);
                    break;
                  case AnimationStatus.dismissed:
                    controller.forward();
                    break;
                  default:
                }
                showAccordion = !showAccordion;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: widget.titleborderColor,
                  color: showAccordion ? widget.expandedTitlebackgroundColor: widget.collapsedTitlebackgroundColor),
              padding:  widget.titlePadding
                  ,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: widget.title != null
                        ? Text(widget.title, style: widget.textStyle)
                        : (widget.child ?? Container()),
                  ),
                  showAccordion ? widget.expandedIcon : widget.collapsedIcon
                ],
              ),
            ),
          ),
          showAccordion
              ? Container(
                  decoration: BoxDecoration(
                    border: widget.contentBorderColor,
                    color: widget.contentbackgroundColor != null
                        ? widget.contentbackgroundColor
                        : Colors.white70,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: widget.contentPadding ,
                  child: SlideTransition(
                    position: offset,
                    child: widget.content != null
                        ? Text(widget.content)
                        : (widget.contentChild ?? Container()),
                  ))
              : Container()
        ],
      ),
    );
  }
}
