abstract class NavigationState {}

class NavigationInitial extends NavigationState {}

class NavigationItemChanged extends NavigationState {
  final int index;
  NavigationItemChanged(this.index);
}