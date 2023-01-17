import 'dart:html';

T select<T extends Element>(String selector) => querySelector(selector)! as T;
