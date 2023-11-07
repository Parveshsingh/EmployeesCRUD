
class ParentState{
  dynamic state;
  dynamic data;
  ParentState({this.state,this.data});
}

class InitState extends ParentState{}

class BlocState extends ParentState{
  BlocState({state,data}) : super(state: state,data: data);
}

class BlocEvent {
  dynamic event;
  dynamic data;

  BlocEvent({this.event,this.data});
}