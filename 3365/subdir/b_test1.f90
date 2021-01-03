!!----
!!----
!!----
SubModule (Test_1) SubTest2
   Contains
   
   Module function get_n ( this ) result(k)
    class(type_1), intent(in) :: this
    integer                   :: k
    
    k=this%n
    
  end function get_n
  
End SubModule SubTest2   