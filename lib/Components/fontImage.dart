import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecoFontImage {
  BoxDecoration fontClair() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/fond_light.png'),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
      ),
    );
  }

  BoxDecoration fontDark() {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/fond_dark.png'),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
      ),
    );
  }
}
