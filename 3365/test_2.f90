module test_2
  use test_1, only: type_1
  

interface

  module subroutine set_m ( this, m )
    class(type_1), intent(inout) :: this
    integer,       intent(in) :: m
  end subroutine

  

end interface

end module test_2


