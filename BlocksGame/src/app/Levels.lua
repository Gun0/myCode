local Levels = class("Levels")

Levels.BLOCKS_TYPE = {
    "a","b","c","d",
    "ab","e","f","cd",
    "g","h","ef","i",
    "j","gh","k","l",
    "ij","m","n","kl",
    "o","p","mn","q",
    "r","op"
}

Levels.BLOCKS_COUNT = {
    3,4,5,6,
    7,8,9,10,
    11,12,13,14,
    15,16,17,18,
    19,20,21,22,
    23,24,25,26
}
--Levels.BLOCKS_LIST_1 = {
--    ["-10"]=0,["-11"]=0,["-12"]=0,
--    ["00"]=0,["01"]=0,["02"]=0,
--    ["10"]=0,["11"]=0,["12"]=0,
--    ["20"]=0,["21"]=0,["22"]=0,
--    ["30"]=0,["31"]=0,["32"]=0
--}

Levels.COL_DOWN = {
    ["-10"] ={"-10","00","10","20","30","40"},
    ["-11"] ={"-11","01","11","21","31","41"},
    ["-12"] ={"-12","02","12","22","32","42"},
    ["-13"] ={"-13","03","13","23","33","43"}
}
Levels.COL_UP = {
    ["40"] ={"40","30","20","10","00","-10"},
    ["41"] ={"41","31","21","11","01","-11"},
    ["42"] ={"42","32","22","12","02","-12"},
    ["43"] ={"43","33","23","13","03","-13"}
}
Levels.COL_UP2 = {
    ["30"] ={"30","20","10","00","-10"},
    ["31"] ={"31","21","11","01","-11"},
    ["32"] ={"32","22","12","02","-12"},
    ["33"] ={"33","23","13","03","-13"}
}
Levels.ROW_1 = {
    {"00","01","02"},
    {"10","11","12"},
    {"20","21","22"}
}

Levels.ROW_2 = {
    {"00","01","02","03"},
    {"10","11","12","13"},
    {"20","21","22","23"},
    {"30","31","32","33"}
}
--Levels.BLOCKS_LIST_2 = {
--    ["-10"]=0,["-11"]=0,["-12"]=0,["-13"]=0,
--    ["00"]=0,["01"]=0,["02"]=0,["03"]=0,
--    ["10"]=0,["11"]=0,["12"]=0,["13"]=0,
--    ["20"]=0,["21"]=0,["22"]=0,["23"]=0,
--    ["30"]=0,["31"]=0,["32"]=0,["33"]=0,
--    ["40"]=0,["41"]=0,["42"]=0,["43"]=0
--}
Levels.BLOCKS_TOUCH_1 = {
    "-10","-11","-12",
    "30","31","32"
}
Levels.BLOCKS_TOUCH_2 = {
    "-10","-11","-12","-13",
    "40","41","42","43"
}

Levels.TARGET_POS_1 = {
    "00","10","20","02","12","22"
}

Levels.TARGET_POS_2 = {
    "00","01","02",
    "10","11","12",
    "20","21","22",
}

Levels.TARGET_POS_3 = {
    "00","01","02","03",
    "10","11","12","13",
    "20","21","22","23",
    "30","31","32","33",
}
return Levels