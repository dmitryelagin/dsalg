import 'dart:html';

T select<T extends Element>(String selector) => querySelector(selector)! as T;

void onButtonClick(String selector, void Function() handleClick) {
  select<ButtonElement>(selector)
      .addEventListener('click', (_) => handleClick());
}
