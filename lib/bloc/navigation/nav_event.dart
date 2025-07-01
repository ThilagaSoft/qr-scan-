abstract class NavigationEvent {}

class NavigationItemSelected extends NavigationEvent {
  final int index;
  NavigationItemSelected(this.index);
}
