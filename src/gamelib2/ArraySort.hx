package gamelib2;

class ArraySort
{
/** 
   Merge Sort (Karg)
**/
  public static function mergesort<T>(a : Array<T>, comparator : T -> T -> Int) : Array<T>
  {
    //Arrays of length 1 and 0 are always sorted
    if(a.length <= 1) 
    {
      return a;
    }
    else
    {
      var middle : Int = Std.int(a.length / 2);

      //split the array into two
      var left  : Array<T> = new Array(/*middle*/);
      var right : Array<T> = new Array(/*a.length-middle*/);

      var j : Int = 0;
      var k : Int = 0;

      //fill the left array
      //for(var i:uint = 0; i < middle; i++)
      for(i in 0...middle)
      {
        left[j++]=a[i];
      }

      //fill the right array
      //for(i = middle; i< a.length; i++)
      for(i in middle...a.length)
      {
        right[k++]=a[i];
      }

      //sort the arrays
      left = mergesort(left, comparator);
      right = mergesort(right, comparator);

      //If the last element of the left array is less than or equal to the first
      //element of the right array, they are in order and don't need to be merged

      //if (left[left.length-1] <= right[0])
      if (comparator(left[left.length-1], right[0]) <= 0)
      {
        return left.concat(right);
      }
      
      a = merge(left, right, comparator);

      return a;
    }
  }
  
/** 
   Merge Sort internal method (Karg)
**/   
  private static function merge<T>(left : Array<T>, right : Array<T>, comparator : T -> T -> Int)
  {
    var result : Array<T> = new Array(/*left.length + right.length*/);
    
    var j : Int = 0;
    var k : Int = 0;
    var m : Int = 0;
    //merge the arrays in order
    while(j < left.length && k < right.length)
    {
      //if(left[j] <= right[k])
      if(comparator(left[j], right[k]) <= 0)
        result[m++] = left[j++];
      else
        result[m++] = right[k++];
    }

    //If one of the arrays has remaining entries that haven't been merged, they
    //will be greater than the rest of the numbers merged so far, so put them on the
    //end of the array.

    //for(; j < left.length; j++)
    while(j < left.length)
    {
      result[m++] = left[j];
      j++;
    }

    //for(; k < right.length; k++)
    while(k < right.length)
    {
      result[m++] = right[k];
      k++;
    }

    return result;
  }
}