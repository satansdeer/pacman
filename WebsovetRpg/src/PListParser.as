/**
 * 
 * Copyright (c) 2008 Christoffer Lerno (Original)
 * Copyright (c) 2009 Eric Daugherty (This Version)
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package
{	
	/**
	 * Provides entry point for parsing PList XML Files.
	 * 
	 * This version does not handle REAL or DATA values.
	 * 
	 * This version is based on the XMLWise Plist.java class
	 * (http://code.google.com/p/xmlwise) written by Christoffer Lerno
	 * 
	 * @author Eric Daugherty
	 * @author Christoffer Lerno
	 */
	public dynamic class PListParser
	{		
		public function PListParser()
		{			
		}
		
		public function parsePList(xml:XMLList) : Object
		{
			if(xml.name() != "plist") throw "Root Exlement must be 'plist'.  Found: " + xml.name();
			
			if(xml.children().length() != 1) throw "'plist' element must contain a single 'dict' element.  Found Multiple child elements";					
			
			return parseXML(XML(xml.dict));
		} 
		
		private function parseXML(xml:XML) : Object
		{
			var type:String = xml.name().toString().toUpperCase();
			switch (type)
			{
				case "INTEGER":
					return int(xml.text());
				case "REAL":
					trace("Ignoring REAL Element");
					return ""; //return Double.valueOf(element.getValue());
				case "STRING":
					return xml.text();
				case "DATE":
					return xml.text();
				case "DATA":
					trace("Ignoring DATA Element");
					return "";
				case "ARRAY":
					return parseArray(xml);
				case "TRUE":
					return true;
				case "FALSE":
					return false;
				case "DICT":
					return parseDict(xml);	            					
				default:
					throw "Unexpected type: " + xml.name();
			}
			
			return null;
		}
		
		private function parseDict(xml:XML) : Object
		{
			var object:Object = new Object();
			var key:String;
			for each(var node:XML in xml.children())
			{
				if(node.name() == "key")
				{
					key = node.text();
				}
				else
				{					
					object[key] = parseXML(node);					
				}
			}
			
			return object;
		}
		
		private function parseArray(xml:XML) : Object
		{
			var array:Array = new Array();
			for each(var node:XML in xml.children())
			{
				array.push(parseXML(node));
			}
			return array;
		}
		
	}
}