class Tuple4<T1, T2, T3, T4> {
  final T1 item1;
  final T2 item2;
  final T3 item3;
  final T4 item4;

  Tuple4(this.item1, this.item2, this.item3, this.item4);

  @override
  String toString(){
    return "("+item1.toString()+","+item2.toString()+";"+item3.toString()+","+item4.toString()+")";
  }
}

class Tuple2<T1, T2>{
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
  @override
  String toString(){
    return "("+item1.toString()+","+item2.toString()+")";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    if (!(other is Tuple2<T1, T2>)) return false;
    return other.item1 == item1 && other.item2 == item2;
  }
}