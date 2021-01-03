!!----
!!----
!!----
SubModule (Test_2) SubTest3
   Contains
   
   module subroutine set_m ( this, m )
     class(type_1), intent(inout) :: this
     integer,       intent(in) :: m
     
     this%n=m*3
  end subroutine set_m
  
End SubModule SubTest3   