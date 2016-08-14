import
  nimbench,
  lists, ../faststack

const
  Count = 100_000       # Number of elements in collection
  StackInitSize = 1_000 # Initial FastStack size

type
  Elem = ref object of RootObj
    data: pointer

var
  tSeq: seq[Elem] = @[]
  tList: DoublyLinkedList[Elem] = initDoublyLinkedList[Elem]()
  tStack: FastStack[Elem] = newFastStack[Elem](StackInitSize)

for idx in 1..Count:
  let n = 100
  var e1 = new Elem
  e1.data = cast[ptr[int]](alloc(n * sizeof(int)))
  cast[ptr[int]](e1.data)[] = n
  tSeq.add(e1)
  var e2 = new Elem
  e2.data = cast[ptr[int]](alloc(n * sizeof(int)))
  cast[ptr[int]](e2.data)[] = n
  tList.append(e2)
  var e3 = new Elem
  e3.data = cast[ptr[int]](alloc(n * sizeof(int)))
  cast[ptr[int]](e3.data)[] = n
  tStack.add(e3)

# BENCHMARK

bench(Sequence, m):
  var d = 0
  for idx in 1..m:
    for item in tSeq.items:
      d += cast[ptr[int]](item.data)[]
  doNotOptimizeAway(d)

bench(List, m):
  var d = 0
  for idx in 1..m:
    for item in tList.items:
      d += cast[ptr[int]](item.data)[]
  doNotOptimizeAway(d)

bench(FastStack, m):
  var d = 0
  for idx in 1..m:
    for item in tStack.items:
      d += cast[ptr[int]](item.data)[]
  doNotOptimizeAway(d)

runBenchmarks()

