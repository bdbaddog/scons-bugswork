!!----
!!----
!!----
SubModule (Test_1) SubTest1
   Contains
   
   module subroutine set_n (this, n)
      class(type_1), intent(inout) :: this
      integer,       intent(in) :: n


      this%n = n
   end Subroutine set_n
  
End SubModule SubTest1