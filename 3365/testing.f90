program testing

  use test_1
  use test_2

  type(type_1) :: var1, var2
 

  call set_n(var1,69)
  call set_m(var2,12)

  print*,'value for var1= ', get_n(var1)
  print*,'value for var2= ', get_n(var2)

end program testing
