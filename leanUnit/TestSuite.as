/*
Example:

var suite = new TestSuite( StringTest, ArrayTest )
suite.run()

TestSuite extends Array so you can also do things like:

var suite = new TestSuite()
suite[0] = ArrayTest
suite.push( StringTest )
suite.run()

*/

import leanUnit.*

class leanUnit.TestSuite extends Array
{
	var testCount:Number = 0
	var assertionCount:Number = 0
	var failures:Array = new Array()
	var timeTaken:Number
	var output:Object
	
	//-------------------------------------------------------------------
	//	CONSTRUCTOR
	//-------------------------------------------------------------------
	
	function TestSuite()
	{
		push.apply(this, arguments)
	}
	
	//-------------------------------------------------------------------
	//	PUBLIC FUNCTIONS
	//-------------------------------------------------------------------
	
	function run(outputMethod)
	{
		output = new ( outputMethod || leanUnit.Output.TracePrinter )()
    output.writeln()
		output.writeln( "Running "+caseNames.join(', ') )
	
		reset()
		iterateAndRun()
		reportResults()
	}
	
	//-------------------------------------------------------------------
	//	PRIVATE FUNCTIONS
	//-------------------------------------------------------------------
	
	private function reset()
	{
		testCount = 0
		assertionCount = 0
		failures = new Array()
	}
	
	private function iterateAndRun()
	{
		var startTime = getTimer()
		for( var i=0; i<length; i++ )
		{
			var testCase = new this[i]()
			while ( runCase( testCase ) )
      {
        testCount += 1
      }
		}
		timeTaken = getTimer() - startTime
	}
	
	private function runCase( testCase:TestCase )
	{
		var result = testCase.runTest()
		var assertions = result[1]
		
		for ( var i in assertions )
		{
			if ( assertions[i] instanceof Failure )
			{
				failures.push(assertions[i])
				output.addFail()
			}
			else
			{
				output.addSuccess()
			}
		}
		
		assertionCount += result[1].length
		
		return result[0]
	}
	
	private function reportResults()
	{
		output.writeln()
		output.writeln('Finished in '+(timeTaken/1000.0)+' seconds')
		
		for( var i=0; i<failures.length; i++ )
		{
			output.writeln()
			output.writeln( (i+1)+")")
			output.writeln( failures[i], "fail" )
		}
		
		output.writeln()
		output.writeln( testCount+" tests, "+assertionCount+" assertions, "+failures.length+" failures", failures.length > 0 ? 'fail' : 'success' )
	}
	
	function get caseNames():Array
	{
		var names = new Array()
		for( var i=0; i<length; i++ )
		{
			var instance = new this[i]()
			names.push(instance.className)
		}
		return names
	}
}
