module test_1

  !---- Definition 
  type type_1
    integer :: n    
  end type type_1


interface

  module pure subroutine set_n ( this, n )
    class(type_1), intent(inout) :: this
    integer,       intent(in)    :: n
  end subroutine

  module function get_n ( this ) result(k)
    class(type_1), intent(in) :: this
    integer                   :: k
  end function get_n

end interface

end module test_1


