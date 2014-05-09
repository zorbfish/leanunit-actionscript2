
class leanUnit.Output.TracePrinter
{
	function write(message)
	{
		trace( message || '' )
	}
	
	function writeln(message)
	{
		write( message )
	}
	
	function addSuccess()
	{
		write( '.' )
	}
	
	function addFail()
	{
		write( 'F' )
	}
}
