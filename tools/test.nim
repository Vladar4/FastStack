import
  unittest,
  ../faststack


proc newEmpty(): FastStack[int] =
  # [_, _, _, _, _]
  result = newFastStack[int](5)


proc newFillL(): FastStack[int] =
  # [1, 2, 3, _, _]
  result = newFastStack[int](5)
  for idx in 1..3:
    result.add(idx)


proc newFillR(): FastStack[int] =
  # [_, _, 3, 4, 5]
  result = newFastStack[int](5)
  for idx in 1..5:
    result.add(idx)
  for idx in 1..2:
    discard result.pull()


proc newFillC(): FastStack[int] =
  # [_, 2, 3, 4, _]
  result = newFastStack[int](5)
  for idx in 1..4:
    result.add(idx)
  discard result.pull()


proc newFillA(): FastStack[int] =
  # [1, 2, 3, 4, 5]
  result = newFastStack[int](5)
  for idx in 1..5:
    result.add(idx)


var
  sEmpty = newEmpty()
  sFillL = newFillL()
  sFillR = newFillR()
  sFillC = newFillC()
  sFillA = newFillA()

import terminal

styledEcho styleBright, fgWhite, "Testing FastStack:"
echo "=================="


test "Stringify test":
  require $sEmpty == "[]"
  require $sFillL == "[1, 2, 3]"
  require $sFillR == "[3, 4, 5]"
  require $sFillC == "[2, 3, 4]"
  require $sFillA == "[1, 2, 3, 4, 5]"


test "Test indexIsValid proc":
  let
    validEmpty = [false, false, false, false, false]
    validFillL = [true, true, true, false, false]
    validFillR = [false, false, true, true, true]
    validFillC = [false, true, true, true, false]
    validFillA = [true, true, true, true, true]
  for idx in 0..4:
    check sEmpty.indexIsValid(idx) == validEmpty[idx]
    check sFillL.indexIsValid(idx) == validFillL[idx]
    check sFillR.indexIsValid(idx) == validFillR[idx]
    check sFillC.indexIsValid(idx) == validFillC[idx]
    check sFillA.indexIsValid(idx) == validFillA[idx]


test "Test len proc":
  check sEmpty.len == 0
  check sFillL.len == 3
  check sFillR.len == 3
  check sFillC.len == 3
  check sFillA.len == 5


test "Test items iterator":
  let
    iFillL = [1, 2, 3]
    iFillR = [3, 4, 5]
    iFillC = [2, 3, 4]
    iFillA = [1, 2, 3, 4, 5]

  var count = 0
  for i in sEmpty.items:
    inc count
  check count == 0

  template cycle(o: FastStack, i: openarray[int]) =
    var idx = 0
    for item in o.items:
      check item == i[idx]
      inc idx

  cycle sFillL, iFillL
  cycle sFillR, iFillR
  cycle sFillC, iFillC
  cycle sFillA, iFillA

test "Test pairs iterator":
  let
    iFillL = [(0, 1), (1, 2), (2, 3)]
    iFillR = [(2, 3), (3, 4), (4, 5)]
    iFillC = [(1, 2), (2, 3), (3, 4)]
    iFillA = [(0, 1), (1, 2), (2, 3), (3, 4), (4, 5)]

  template cycle(o: FastStack, i: openarray[(int, int)]) =
    var idx = 0
    for item in o.pairs:
      check item == i[idx]
      inc idx

  cycle sFillL, iFillL
  cycle sFillR, iFillR
  cycle sFillC, iFillC
  cycle sFillA, iFillA


test "Test add proc":
  let
    addEmpty = "[11, 12, 13, 14, 15]"
    addFillL = "[1, 2, 3, 11, 12, 13, 14, 15]"
    addFillR = "[3, 4, 5, 11, 12, 13, 14, 15]"
    addFillC = "[2, 3, 4, 11, 12, 13, 14, 15]"
    addFillA = "[1, 2, 3, 4, 5, 11, 12, 13, 14, 15]"

  for idx in 11..15:
    sEmpty.add(idx)
    sFillL.add(idx)
    sFillR.add(idx)
    sFillC.add(idx)
    sFillA.add(idx)

  check $sEmpty == addEmpty
  check $sFillL == addFillL
  check $sFillR == addFillR
  check $sFillC == addFillC
  check $sFillA == addFillA


test "Test pull proc":
  let
    pulledEmpty = [11, 12]
    afterEmpty = "[13, 14, 15]"
    pulledFillL = [1, 2]
    afterFillL = "[3, 11, 12, 13, 14, 15]"
    pulledFillR = [3, 4]
    afterFillR = "[5, 11, 12, 13, 14, 15]"
    pulledFillC = [2, 3]
    afterFillC = "[4, 11, 12, 13, 14, 15]"
    pulledFillA = [1, 2]
    afterFillA = "[3, 4, 5, 11, 12, 13, 14, 15]"

  check pulledEmpty[0] == sEmpty.pull()
  check pulledEmpty[1] == sEmpty.pull()
  check $sEmpty == afterEmpty
  check pulledFillL[0] == sFillL.pull()
  check pulledFillL[1] == sFillL.pull()
  check $sFillL == afterFillL
  check pulledFillR[0] == sFillR.pull()
  check pulledFillR[1] == sFillR.pull()
  check $sFillR == afterFillR
  check pulledFillC[0] == sFillC.pull()
  check pulledFillC[1] == sFillC.pull()
  check $sFillC == afterFillC
  check pulledFillA[0] == sFillA.pull()
  check pulledFillA[1] == sFillA.pull()
  check $sFillA == afterFillA

test "Test push proc":
  let
    pushEmpty = "[21, 22, 23, 24, 25, 13, 14, 15]"
    pushFillL = "[21, 22, 23, 24, 25, 3, 11, 12, 13, 14, 15]"
    pushFillR = "[21, 22, 23, 24, 25, 5, 11, 12, 13, 14, 15]"
    pushFillC = "[21, 22, 23, 24, 25, 4, 11, 12, 13, 14, 15]"
    pushFillA = "[21, 22, 23, 24, 25, 3, 4, 5, 11, 12, 13, 14, 15]"

  for idx in countdown(25, 21):
    sEmpty.push(idx)
    sFillL.push(idx)
    sFillR.push(idx)
    sFillC.push(idx)
    sFillA.push(idx)

  check $sEmpty == pushEmpty
  check $sFillL == pushFillL
  check $sFillR == pushFillR
  check $sFillC == pushFillC
  check $sFillA == pushFillA


test "Test pop proc":
  let
    popped = [15, 14]
    afterEmpty = "[21, 22, 23, 24, 25, 13]"
    afterFillL = "[21, 22, 23, 24, 25, 3, 11, 12, 13]"
    afterFillR = "[21, 22, 23, 24, 25, 5, 11, 12, 13]"
    afterFillC = "[21, 22, 23, 24, 25, 4, 11, 12, 13]"
    afterFillA = "[21, 22, 23, 24, 25, 3, 4, 5, 11, 12, 13]"

  check popped[0] == sEmpty.pop()
  check popped[1] == sEmpty.pop()
  check $sEmpty == afterEmpty
  check popped[0] == sFillL.pop()
  check popped[1] == sFillL.pop()
  check $sFillL == afterFillL
  check popped[0] == sFillR.pop()
  check popped[1] == sFillR.pop()
  check $sFillR == afterFillR
  check popped[0] == sFillC.pop()
  check popped[1] == sFillC.pop()
  check $sFillC == afterFillC
  check popped[0] == sFillA.pop()
  check popped[1] == sFillA.pop()
  check $sFillA == afterFillA


test "Test find and [] proc":
  let
    iEmpty = [21, 22, 23, 24, 25, 13]
    iFillL = [21, 22, 23, 24, 25, 3, 11, 12, 13]
    iFillR = [21, 22, 23, 24, 25, 5, 11, 12, 13]
    iFillC = [21, 22, 23, 24, 25, 4, 11, 12, 13]
    iFillA = [21, 22, 23, 24, 25, 3, 4, 5, 11, 12, 13]

  for idx in 0..high(iEmpty):
    check sEmpty[sEmpty.find(iEmpty[idx])] == iEmpty[idx]
  for idx in 0..high(iFillL):
    check sFillL[sFillL.find(iFillL[idx])] == iFillL[idx]
  for idx in 0..high(iFillR):
    check sFillR[sFillR.find(iFillR[idx])] == iFillR[idx]
  for idx in 0..high(iFillC):
    check sFillC[sFillC.find(iFillC[idx])] == iFillC[idx]
  for idx in 0..high(iFillA):
    check sFillA[sFillA.find(iFillA[idx])] == iFillA[idx]


test "Test contains proc":
  check sEmpty.contains(25)
  check(not sEmpty.contains(14))
  check sFillL.contains(3)
  check(not sFillL.contains(15))
  check sFillR.contains(5)
  check(not sFillR.contains(14))
  check sFillC.contains(4)
  check(not sFillC.contains(15))
  check sFillA.contains(11)
  check(not sFillA.contains(15))


test "Test inject proc":
  let
    afterEmpty = "[21, 22, 23, 24, 31, 32, 25, 13]"
    afterFillL = "[21, 22, 23, 24, 31, 32, 25, 3, 11, 12, 13]"
    afterFillR = "[21, 22, 23, 24, 31, 32, 25, 5, 11, 12, 13]"
    afterFillC = "[21, 22, 23, 24, 31, 32, 25, 4, 11, 12, 13]"
    afterFillA = "[21, 22, 23, 24, 31, 32, 25, 3, 4, 5, 11, 12, 13]"

  for idx in 31..32:
    sEmpty.inject(idx, sEmpty.find(25))
    sFillL.inject(idx, sFillL.find(25))
    sFillR.inject(idx, sFillR.find(25))
    sFillC.inject(idx, sFillC.find(25))
    sFillA.inject(idx, sFillA.find(25))

  check $sEmpty == afterEmpty
  check $sFillL == afterFillL
  check $sFillR == afterFillR
  check $sFillC == afterFillC
  check $sFillA == afterFillA

  var sBorderline = newFastStack[int](5)
  for idx in 1..5:
    sBorderline.add(idx)
  sBorderline.inject(45, 4)
  check $sBorderline == "[1, 2, 3, 4, 45, 5]"
  sBorderline.inject(0, 0)
  check $sBorderline == "[0, 1, 2, 3, 4, 45, 5]"


test "Test eject proc":
  let
    ejectedEmpty = [21, 23, 32, 25, 13]
    afterEmpty = "[22, 24, 31]"
    ejectedFillL = [21, 23, 32, 11, 13]
    afterFillL = "[22, 24, 31, 25, 3, 12]"
    ejectedFillR = [21, 23, 32, 11, 13]
    afterFillR = "[22, 24, 31, 25, 5, 12]"
    ejectedFillC = [21, 23, 32, 11, 13]
    afterFillC = "[22, 24, 31, 25, 4, 12]"
    ejectedFillA = [21, 23, 32, 5, 13]
    afterFillA = "[22, 24, 31, 25, 3, 4, 11, 12]"

  for idx in 0..4:
    check ejectedEmpty[idx] == sEmpty.eject(sEmpty.find(ejectedEmpty[idx]))
    check ejectedFillL[idx] == sFillL.eject(sFillL.find(ejectedFillL[idx]))
    check ejectedFillR[idx] == sFillR.eject(sFillR.find(ejectedFillR[idx]))
    check ejectedFillC[idx] == sFillC.eject(sFillC.find(ejectedFillC[idx]))
    check ejectedFillA[idx] == sFillA.eject(sFillA.find(ejectedFillA[idx]))

  check $sEmpty == afterEmpty
  check $sFillL == afterFillL
  check $sFillR == afterFillR
  check $sFillC == afterFillC
  check $sFillA == afterFillA

  var sBorderline = newFastStack[int](5)
  for idx in 1..5:
    sBorderline.add(idx)
  check 5 == sBorderline.eject(4)
  check $sBorderline == "[1, 2, 3, 4]"
  check 1 == sBorderline.eject(0)
  check $sBorderline == "[2, 3, 4]"


test "Test firstVal, lastVal, and []= proc":
  let
    after = [44, 576, 24]

  sEmpty.add(12)

  template modify(o: FastStack) =
    var idx = o.find(o.firstVal)
    o[idx] = o[idx] * 2
    idx = o.find(24)
    o[idx] = o[idx] * o[idx]
    idx = o.find(o.lastVal)
    o[idx] = o[idx] + o[idx]

  modify(sEmpty)
  modify(sFillL)
  modify(sFillR)
  modify(sFillC)
  modify(sFillA)

  template validate(o: FastStack) =
    check o.firstVal == after[0]
    check o[o.find(576)] == after[1]
    check o.lastVal == after[2]

  validate sEmpty
  validate sFillL
  validate sFillR
  validate sFillC
  validate sFillA


test "Test firstKey, lastKey":

  check sEmpty.find(sEmpty.firstVal) == sEmpty.firstKey
  check sFillR.find(sFillR.firstVal) == sFillR.firstKey
  check sFillL.find(sFillL.firstVal) == sFillL.firstKey
  check sFillC.find(sFillC.firstVal) == sFillC.firstKey
  check sFillA.find(sFillA.firstVal) == sFillA.firstKey

  check sEmpty.find(sEmpty.lastVal) == sEmpty.lastKey
  check sFillR.find(sFillR.lastVal) == sFillR.lastKey
  check sFillL.find(sFillL.lastVal) == sFillL.lastKey
  check sFillC.find(sFillC.lastVal) == sFillC.lastKey
  check sFillA.find(sFillA.lastVal) == sFillA.lastKey


test "Allocation test":

  var sAlloc = newFastStack[ptr[int]](10)
  for idx in 1..10_000:
    sAlloc.add(cast[ptr[int]](alloc(100 * sizeof(int))))
    sAlloc.mLastVal[] = idx

  var x = 1
  for item in sAlloc.items:
    check sAlloc[x - 1][] == x
    inc x


echo "=================="
if programResult == 0:
  styledEcho styleBright, fgGreen, "      PASSED      "
else:
  styledEcho styleBright, fgRed, "      FAILED      "

