import leanUnit.*

/*

Example:

// StringTest.as
class StringTest extends leanUnit.TestCase
{
	var string:String
	
	function setup()
	{
		string = 'Asdf'
	}
	
	function testLength()
	{
		assertEqual(4, string.length)
	}
	
	function testToUpperCase()
	{
		assertEqual( 'ASDF', string.toUpperCase() )
	}
	
	function teardown()
	{
		delete string
	}
}

*/

class leanUnit.TestCase extends Assertions
{
	private var _testMethods:Array
	private var _timeTaken
	private var _testsRun

	var setUp:Function
	var tearDown:Function
	
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------

	function TestCase()
	{
		className = Reflection.getClassName(this)
		className = className.substr(className.lastIndexOf('.')+1) // remove namespace
	
		failures = new Array()
		_testsRun = 0
		assertionCount = 0
	}
	
	//-------------------------------------------------------------------
	//	PUBLIC METHODS
	//-------------------------------------------------------------------
	
	function runTest()
	{
    if (testMethods.length > 0)
    {
      runMethod(testMethods[_testsRun])
      _testsRun += 1
    }
		return [testMethods.length - _testsRun, failures]
	}
	
	function toString()
	{
		return className
	}
	
	//-------------------------------------------------------------------
	//	PRIVATE METHODS
	//-------------------------------------------------------------------
	
	private function runMethod(methodName)
	{
		currentMethod = methodName
		failures = new Array()
	
		setUp()
		this[methodName]()
		tearDown()
	}
	
	//-------------------------------------------------------------------
	//	PROPERTIES
	//-------------------------------------------------------------------
	
	function get testMethods():Array
	{
		if( !_testMethods )
		{
			_testMethods = new Array();

			_global.ASSetPropFlags(this.__proto__, null, 6, true);
			for(var property:String in this) 
			{
				var value = this[property]
				if( property.indexOf("test") == 0 && value instanceof Function )
				{
					_testMethods.push(property)
				}
			}
			_global.ASSetPropFlags(this.__proto__, null, 1, true);
		
			_testMethods.reverse()
		}
		
		return _testMethods
	}
}
