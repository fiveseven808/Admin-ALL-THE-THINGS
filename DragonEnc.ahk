DraGon_Enc(mystring)
{
  Random,, %A_now%
  Random, pe_rand1, 2,  6
  Random, pe_rand2, 4,  7
  Random, pe_rand3, 10, 90

  allstr := pe_rand1

  Loop, parse, mystring
    allstr .= (((asc(A_LoopField)+pe_rand1)*pe_rand2)+pe_rand3)

  Return chr(SubStr(pe_rand3,0)+64) . allstr . pe_rand2 . chr(SubStr(pe_rand3,1,1)+64)
}

DraGon_Dec(allstr)
{
  pd_rand3 := ( asc(SubStr(allstr,0)) - 64 ) . ( asc(SubStr(allstr,1,1)) - 64 )
  pd_rand1 := SubStr(allstr,2,1)
  pd_rand2 := SubStr(allstr,-1,1)

  allstr := SubStr(allstr,3,StrLen(allstr)-2)

  Loop, % StrLen(allstr)/3
  {
    ps_word .= chr((((SubStr(allstr,1,3)-pd_rand3)/pd_rand2)-pd_rand1))
    allstr := SubStr(allstr,4)
  }
 
  Return ps_word
}