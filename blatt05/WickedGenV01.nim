import os
import strutils
import bitops
import json
import math
import parseutils
import random

# check if path to json file is provided
if paramCount() < 1:
  raise newException(IOError,"please provide path to config file")
  
# parse json
var path_config_file = paramStr(1)
let jsonNode = parseFile(path_config_file)

# initialize json variables
var bus:int = jsonNode["bus"].getInt()
var page:int = jsonNode["page"].getInt()
var ram:int = jsonNode["ram"].getInt()
var table:string = jsonNode["table"].getStr()
var entry:int = jsonNode["entry"].getInt()
var cmd:string = jsonNode["cmd"].getStr()
var parameters = jsonNode["parameters"]

# Aufgabe a) es werden dezimal eingelesen und ausgegeben 
proc decompose(log_adress: int, phy_adress: int) =
  var offset, p = log_adress
  var f = phy_adress
  var max_bit = ceil(log2(log_adress.float))
  var max_bit_2 = ceil(log2(phy_adress.float))

  offset.bitslice(0..page-1)
  p.bitslice(12..max_bit.int)
  f.bitslice(12..max_bit_2.int)

  assert(p > 2^52, "Seitennummer größer als Anzahl Einträge")
  assert(offset > 2^12, "offset größer als Seite")

  echo log_adress, ", ", phy_adress, ", ", p, ", ", f, ", ", offset

# Aufgabe b)
proc genRandomTranslations(N: int, max_p: int, max_f: int, max_of: int) =
  randomize()
  for i in 0..N:
    let p = rand(max_p)
    let f = rand(max_f)
    let off = rand(max_of)
    let log_ad = (p*2^12+off)
    let phy_ad = (f*2^12+off)
    echo log_ad, ", ", phy_ad, ", ", p, ", ", f, ", ", off
  
proc discernTable(input: seq[int]) =
  for i in countup(0,len(input)-1,3):
    var id = input[i]
    var log_ad = input[i+1]
    var phy_ad = input[i+2]
    var p: int = log_ad
    var f: int = phy_ad
    var max_bit = ceil(log2(log_ad.float))
    var max_bit_2 = ceil(log2(phy_ad.float))
    p.bitslice(12..max_bit.int)
    f.bitslice(12..max_bit_2.int)
    echo "entry index: ", f, " entry content: ", id, ", ", p

if cmd == "decompose":
  var log_adress = parameters[0].getInt()
  var phy_adress = parameters[1].getInt()
  decompose(log_adress,phy_adress)

elif cmd == "getRandomTranslations":
  var N = parameters[0].getInt()
  var max_p = parameters[1].getInt()
  var max_f = parameters[2].getInt()
  var max_of = parameters[3].getInt()
  genRandomTranslations(N, max_p, max_f, max_of)

elif cmd == "discernTable":
  if table != "i":
    raise (newException(IOError, "entry it not set for discernTable proc"))
  var input: seq[int] = @[]
  for i in 0..len(parameters)-1:
    input.add(parameters[i].getInt())
  discernTable(input)
