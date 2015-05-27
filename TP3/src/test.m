function a = test1()
end

function b = test2()
end

n = @test1

switch n
	case @test1
	 disp('asdf')
	case @test2
	 disp('bbbb')
end