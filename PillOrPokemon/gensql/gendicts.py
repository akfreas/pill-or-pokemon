import random
import sqlite3

conn = sqlite3.connect('PillOrPokemonData.sqlite')
#conn = conn.cursor()

def getlist(filename, id):
    fpoke = open(filename)
    poker = fpoke.read()
    pokelist = poker.split("\n")

    newlist = []

    for item in pokelist:
        items = item.split("-")
        newlist.append([items[0]])
        newlist[-1].append(id)
        newlist[-1].append(items[1])
    
    return newlist

pokes = getlist("pokemon.txt","pokemon")
pills = getlist("pills.txt","pill")

lists = pokes + pills
random.shuffle(lists)

i=0
for item in lists:
    name = item[0]
    theType = item[1]
    description = [2]
    vals = []
    vals.append(0)
    vals.append(item[2])
    vals.append(item[0])
    vals.append(item[1])
    conn.execute("insert into ZQUIZITEM values(?, ?, ?, ?)", vals)
    i+=1
    #Z_PK INTEGER PRIMARY KEY, Z_ENT INTEGER, Z_OPT INTEGER, ZCORRECT INTEGER, ZITEMDESCRIPTION VARCHAR, ZNAME VARCHAR, ZTYPE VARCHAR
conn.execute("update Z_PRIMARYKEY set Z_MAX=?", [i])
conn.commit()
