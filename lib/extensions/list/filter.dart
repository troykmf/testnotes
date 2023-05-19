/// what we're doing rn is to create an exception to filter the stream

// extension Filter<T> on Stream<List<T>> {
//   Stream<List<T>> filter(bool Funtion(T where)) =>
//       map((items) => items.where(Funtion).toList());
// }

// extension Fiter<T> on Stream<List<T>> {
//   Stream<List<T>> filter(where((bool Funtion(T)) {
//     return map((items) => items.where(where).toList());
//   }));
// }

//learn to filter on/a list
extension Fiter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
