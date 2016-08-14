import
  nimbench,
  lists, ../faststack

const
  Count = 100_000         # Number of elements in collection
  StackInitSize = 1_000   # Initial FastStack size

type
  Elem = ref object of RootObj
    data: int

var
  tSeq: seq[Elem] = @[]
  tList: DoublyLinkedList[Elem] = initDoublyLinkedList[Elem]()
  tStack: FastStack[Elem] = newFastStack[Elem](StackInitSize)

for idx in 1..Count:
  var e = new Elem
  e.data = 100
  tSeq.add(e)
  tList.append(e)
  tStack.add(e)

bench(Sequence, m):
  var d = 0
  for idx in 1..m:
    for item in tSeq.items:
      d += item.data
  doNotOptimizeAway(d)

bench(List, m):
  var d = 0
  for idx in 1..m:
    for item in tList.items:
      d += item.data
  doNotOptimizeAway(d)

bench(FastStack, m):
  var d = 0
  for idx in 1..m:
    for item in tStack.items:
      d += item.data
  doNotOptimizeAway(d)

runBenchmarks()

