package gamelib2.math;

/**
 * <code>Matrix4f</code> defines and maintains a 4x4 matrix in row major order.
 * This matrix is intended for use in a translation and rotational capacity. 
 * It provides convenience methods for creating the matrix from a multitude 
 * of sources.
 * 
 * Matrices are stored assuming column vectors on the right, with the translation
 * in the rightmost column. Element numbering is row,column, so m03 is the zeroth
 * row, third column, which is the "x" translation part. This means that the implicit
 * storage order is column major. However, the get() and set() functions on float
 * arrays default to row major order!
 *
 * @author ported to Haxe
 */
class Matrix4f
{
  public var m00 : Float;
  public var m01 : Float;
  public var m02 : Float;
  public var m03 : Float;

  public var m10 : Float;
  public var m11 : Float;
  public var m12 : Float;
  public var m13 : Float;

  public var m20 : Float;
  public var m21 : Float;
  public var m22 : Float;
  public var m23 : Float;

  public var m30 : Float;
  public var m31 : Float;
  public var m32 : Float;
  public var m33 : Float;

  /**
   * Constructor instantiates a new <code>Matrix</code> that is set to the
   * identity matrix.
   *  
   */
  public function new() 
  {
    loadIdentity();
  }

  /**
   * <code>copy</code> transfers the contents of a given matrix to this
   * matrix. If a null matrix is supplied, this matrix is set to the identity
   * matrix.
   * 
   * @param matrix
   *            the matrix to copy.
   */
  public function copy(matrix : Matrix4f) : Void
  {
    if (null == matrix) 
    {
      loadIdentity();
    } 
    else 
    {
      m00 = matrix.m00;
      m01 = matrix.m01;
      m02 = matrix.m02;
      m03 = matrix.m03;
      m10 = matrix.m10;
      m11 = matrix.m11;
      m12 = matrix.m12;
      m13 = matrix.m13;
      m20 = matrix.m20;
      m21 = matrix.m21;
      m22 = matrix.m22;
      m23 = matrix.m23;
      m30 = matrix.m30;
      m31 = matrix.m31;
      m32 = matrix.m32;
      m33 = matrix.m33;
    }
  }

  /**
   * <code>get</code> retrieves the values of this object into
   * a float array in row-major order.
   * 
   * @param matrix
   *            the matrix to set the values into.
   */
   /*
  public function getAsArray(matrix : Array<Float>)
  {
    getAsArray2(matrix, true);
  }
  */

  /**
   * <code>set</code> retrieves the values of this object into
   * a float array.
   * 
   * @param matrix
   *            the matrix to set the values into.
   * @param rowMajor
   *            whether the outgoing data is in row or column major order.
   */
  public function getAsArray(matrix : Array<Float>, ?rowMajor : Bool = true) : Void
  {
    //if (matrix.length != 16) throw new JmeException(
    //        "Array must be of size 16.");
    for(i in 0...16)
    {
      matrix.push(0.0);
    }

    if (rowMajor) 
    {
      matrix[0] = m00;
      matrix[1] = m01;
      matrix[2] = m02;
      matrix[3] = m03;
      matrix[4] = m10;
      matrix[5] = m11;
      matrix[6] = m12;
      matrix[7] = m13;
      matrix[8] = m20;
      matrix[9] = m21;
      matrix[10] = m22;
      matrix[11] = m23;
      matrix[12] = m30;
      matrix[13] = m31;
      matrix[14] = m32;
      matrix[15] = m33;
    } 
    else 
    {
      matrix[0] = m00;
      matrix[4] = m01;
      matrix[8] = m02;
      matrix[12] = m03;
      matrix[1] = m10;
      matrix[5] = m11;
      matrix[9] = m12;
      matrix[13] = m13;
      matrix[2] = m20;
      matrix[6] = m21;
      matrix[10] = m22;
      matrix[14] = m23;
      matrix[3] = m30;
      matrix[7] = m31;
      matrix[11] = m32;
      matrix[15] = m33;
    }
  }

  /**
   * <code>get</code> retrieves a value from the matrix at the given
   * position. If the position is invalid a <code>JmeException</code> is
   * thrown.
   * 
   * @param i
   *            the row index.
   * @param j
   *            the colum index.
   * @return the value at (i, j).
   */
  public function get(i : Int, j : Int) : Float
  {
    switch (i) 
    {
      case 0:
        switch (j) 
        {
          case 0: return m00;
          case 1: return m01;
          case 2: return m02;
          case 3: return m03;
        }
      case 1:
        switch (j) 
        {
          case 0: return m10;
          case 1: return m11;
          case 2: return m12;
          case 3: return m13;
        }
      case 2:
        switch (j) 
        {
          case 0: return m20;
          case 1: return m21;
          case 2: return m22;
          case 3: return m23;
        }
      case 3:
        switch (j) 
        {
          case 0: return m30;
          case 1: return m31;
          case 2: return m32;
          case 3: return m33;
        }
    }

    trace("Fatal: Invalid matrix index. " + i + ", " + j);
    throw ("Invalid indices into matrix. " + i + ", " + j);
  }

  /**
   * <code>getColumn</code> returns one of three columns specified by the
   * parameter. This column is returned as a float array of length 4.
   * 
   * @param i
   *            the column to retrieve. Must be between 0 and 3.
   * @return the column specified by the index.
   */
  public function getColumnAsArray(i : Int) : Array<Float>
  {
    return getColumnAsArrayStore(i, null);
  }

  /**
   * <code>getColumn</code> returns one of three columns specified by the
   * parameter. This column is returned as a float[4].
   * 
   * @param i
   *            the column to retrieve. Must be between 0 and 3.
   * @param store
   *            the float array to store the result in. if null, a new one
   *            is created.
   * @return the column specified by the index.
   */
  public function getColumnAsArrayStore(i : Int, store : Array<Float>) : Array<Float>
  {
    if (store == null) store = new Array<Float>();

    // make sure the array has room for the elements
    for(i in 0...16 - store.length)
    {
      store.push(0.0);
    }

    switch (i) 
    {
      case 0:
      {
        store[0] = m00;
        store[1] = m10;
        store[2] = m20;
        store[3] = m30;
      }
      case 1:
      {
        store[0] = m01;
        store[1] = m11;
        store[2] = m21;
        store[3] = m31;
      }
      case 2:
      {
        store[0] = m02;
        store[1] = m12;
        store[2] = m22;
        store[3] = m32;
      }
      case 3:
      {
        store[0] = m03;
        store[1] = m13;
        store[2] = m23;
        store[3] = m33;
      }
      default:
      {
        trace("Invalid column index. " + i);
        throw ("Invalid column index. " + i);
      }
    }

    return store;
  }

  /**
   * 
   * <code>setColumn</code> sets a particular column of this matrix to that
   * represented by the provided vector.
   * 
   * @param i
   *            the column to set.
   * @param column
   *            the data to set.
   */
  public function setColumn(i : Int, column : Array<Float>) : Void
  {
    if (column == null) 
    {
        trace("Warning: Column is null. Ignoring.");
        return;
    }

    switch (i) 
    {
      case 0:
      {
        m00 = column[0];
        m10 = column[1];
        m20 = column[2];
        m30 = column[3];
      }
      case 1:
      {
        m01 = column[0];
        m11 = column[1];
        m21 = column[2];
        m31 = column[3];
      }
      case 2:
      {
        m02 = column[0];
        m12 = column[1];
        m22 = column[2];
        m32 = column[3];
      }
      case 3:
      {
        m03 = column[0];
        m13 = column[1];
        m23 = column[2];
        m33 = column[3];
      }
      default:
      {
        trace("Invalid column index. " + i);
        throw ("Invalid column index. " + i);
      }
    }    
  }

  /**
   * <code>set</code> places a given value into the matrix at the given
   * position. If the position is invalid a <code>JmeException</code> is
   * thrown.
   * 
   * @param i
   *            the row index.
   * @param j
   *            the colum index.
   * @param value
   *            the value for (i, j).
   */
  public function set(i : Int, j : Int, value : Float) : Void
  {
    switch (i) 
    {
      case 0:
        switch (j) 
        {
          case 0: m00 = value; return;
          case 1: m01 = value; return;
          case 2: m02 = value; return;
          case 3: m03 = value; return;
        }
      case 1:
        switch (j) 
        {
          case 0: m10 = value; return;
          case 1: m11 = value; return;
          case 2: m12 = value; return;
          case 3: m13 = value; return;
        }
      case 2:
        switch (j) 
        {
          case 0: m20 = value; return;
          case 1: m21 = value; return;
          case 2: m22 = value; return;
          case 3: m23 = value; return;
        }
      case 3:
        switch (j) 
        {
          case 0: m30 = value; return;
          case 1: m31 = value; return;
          case 2: m32 = value; return;
          case 3: m33 = value; return;
        }
    }

    trace("Invalid matrix index. " + i + ", " + j);
    throw ("Invalid indices into matrix. " + i + ", " + j);
  }

  /**
   * <code>set</code> sets the values of this matrix from an array of
   * values.
   * 
   * @param matrix
   *            the matrix to set the value to.
   * @throws JmeException
   *             if the array is not of size 16.
   */
   /*
  public void set(float[][] matrix) {
      if (matrix.length != 4 || matrix[0].length != 4) { throw new JmeException(
              "Array must be of size 16."); }

      m00 = matrix[0][0];
      m01 = matrix[0][1];
      m02 = matrix[0][2];
      m03 = matrix[0][3];
      m10 = matrix[1][0];
      m11 = matrix[1][1];
      m12 = matrix[1][2];
      m13 = matrix[1][3];
      m20 = matrix[2][0];
      m21 = matrix[2][1];
      m22 = matrix[2][2];
      m23 = matrix[2][3];
      m30 = matrix[3][0];
      m31 = matrix[3][1];
      m32 = matrix[3][2];
      m33 = matrix[3][3];
  }
  */

  /**
   * <code>set</code> sets the values of this matrix from another matrix.
   *
   * @param matrix
   *            the matrix to read the value from.
   */
  public function setMatrix(matrix : Matrix4f) : Matrix4f
  {
    m00 = matrix.m00; m01 = matrix.m01; m02 = matrix.m02; m03 = matrix.m03;
    m10 = matrix.m10; m11 = matrix.m11; m12 = matrix.m12; m13 = matrix.m13;
    m20 = matrix.m20; m21 = matrix.m21; m22 = matrix.m22; m23 = matrix.m23;
    m30 = matrix.m30; m31 = matrix.m31; m32 = matrix.m32; m33 = matrix.m33;
    return this;
  }

  /**
   * <code>set</code> sets the values of this matrix from an array of
   * values assuming that the data is rowMajor order;
   * 
   * @param matrix
   *            the matrix to set the value to.
   */
  public function setFromArray(matrix : Array<Float>) : Void
  {
    setFromArrayStore(matrix, true);
  }

  /**
   * <code>set</code> sets the values of this matrix from an array of
   * values;
   * 
   * @param matrix
   *            the matrix to set the value to.
   * @param rowMajor
   *            whether the incoming data is in row or column major order.
   */
  public function setFromArrayStore(matrix : Array<Float>, rowMajor : Bool) : Void
  {
    if (matrix.length != 16)
    {
      throw ("Array must be of size 16.");
    }

    if (rowMajor) 
    {
      m00 = matrix[0];
      m01 = matrix[1];
      m02 = matrix[2];
      m03 = matrix[3];
      m10 = matrix[4];
      m11 = matrix[5];
      m12 = matrix[6];
      m13 = matrix[7];
      m20 = matrix[8];
      m21 = matrix[9];
      m22 = matrix[10];
      m23 = matrix[11];
      m30 = matrix[12];
      m31 = matrix[13];
      m32 = matrix[14];
      m33 = matrix[15];
    } 
    else 
    {
      m00 = matrix[0];
      m01 = matrix[4];
      m02 = matrix[8];
      m03 = matrix[12];
      m10 = matrix[1];
      m11 = matrix[5];
      m12 = matrix[9];
      m13 = matrix[13];
      m20 = matrix[2];
      m21 = matrix[6];
      m22 = matrix[10];
      m23 = matrix[14];
      m30 = matrix[3];
      m31 = matrix[7];
      m32 = matrix[11];
      m33 = matrix[15];
    }
  }

  public function transpose() : Matrix4f
  {
    //float[] tmp = new float[16];
    var tmp = new Array<Float>();

    for(i in 0...16)
    {
      tmp.push(0.0);
    }

    getAsArray(tmp, true);

    var result = new Matrix4f();

    result.setFromArray(tmp);

    return result;
  }

  /**
   * <code>transpose</code> locally transposes this Matrix.
   * 
   * @return this object for chaining.
   */
  public function transposeLocal() : Matrix4f
  {
    var tmp : Float = m01;
    m01 = m10;
    m10 = tmp;
    
    tmp = m02;
    m02 = m20;
    m20 = tmp;
    
    tmp = m03;
    m03 = m30;
    m30 = tmp;
    
    tmp = m12;
    m12 = m21;
    m21 = tmp;
    
    tmp = m13;
    m13 = m31;
    m31 = tmp;
    
    tmp = m23;
    m23 = m32;
    m32 = tmp;

    return this;
  }
  
  
  /**
   * <code>toFloatBuffer</code> returns a FloatBuffer object that contains
   * the matrix data.
   * 
   * @return matrix data as a FloatBuffer.
   */
  /*
  public FloatBuffer toFloatBuffer() {
    return toFloatBuffer(false);
  }
  */

  /**
   * <code>toFloatBuffer</code> returns a FloatBuffer object that contains the
   * matrix data.
   * 
   * @param columnMajor
   *            if true, this buffer should be filled with column major data,
   *            otherwise it will be filled row major.
   * @return matrix data as a FloatBuffer. The position is set to 0 for
   *         convenience.
   */
   /*
  public FloatBuffer toFloatBuffer(boolean columnMajor) {
    FloatBuffer fb = BufferUtils.createFloatBuffer(16);
    fillFloatBuffer(fb, columnMajor);
    fb.rewind();
    return fb;
  }
  */
  
  /**
   * <code>fillFloatBuffer</code> fills a FloatBuffer object with
   * the matrix data.
   * @param fb the buffer to fill, must be correct size
   * @return matrix data as a FloatBuffer.
   */
   /*
  public FloatBuffer fillFloatBuffer(FloatBuffer fb) {
    return fillFloatBuffer(fb, false);
  }
  */

  /**
   * <code>fillFloatBuffer</code> fills a FloatBuffer object with the matrix
   * data.
   * 
   * @param fb
   *            the buffer to fill, starting at current position. Must have
   *            room for 16 more floats.
   * @param columnMajor
   *            if true, this buffer should be filled with column major data,
   *            otherwise it will be filled row major.
   * @return matrix data as a FloatBuffer. (position is advanced by 16 and any
   *         limit set is not changed).
   */
   /*
  public FloatBuffer fillFloatBuffer(FloatBuffer fb, boolean columnMajor) {
      if(columnMajor) {
        fb.put(m00).put(m10).put(m20).put(m30);
        fb.put(m01).put(m11).put(m21).put(m31);
        fb.put(m02).put(m12).put(m22).put(m32);
        fb.put(m03).put(m13).put(m23).put(m33);
    } else {
        fb.put(m00).put(m01).put(m02).put(m03);
        fb.put(m10).put(m11).put(m12).put(m13);
        fb.put(m20).put(m21).put(m22).put(m23);
        fb.put(m30).put(m31).put(m32).put(m33);
    }
      return fb;
  }
  */
  
  /**
   * <code>readFloatBuffer</code> reads value for this matrix from a FloatBuffer.
   * @param fb the buffer to read from, must be correct size
   * @return this data as a FloatBuffer.
   */
   /*
  public Matrix4f readFloatBuffer(FloatBuffer fb) {
    return readFloatBuffer(fb, false);
  }
  */

  /**
   * <code>readFloatBuffer</code> reads value for this matrix from a FloatBuffer.
   * @param fb the buffer to read from, must be correct size
   * @param columnMajor if true, this buffer should be filled with column
   * 		major data, otherwise it will be filled row major.
   * @return this data as a FloatBuffer.
   */
   /*
  public Matrix4f readFloatBuffer(FloatBuffer fb, boolean columnMajor) {
    
    if(columnMajor) {
      m00 = fb.get(); m10 = fb.get(); m20 = fb.get(); m30 = fb.get();
      m01 = fb.get(); m11 = fb.get(); m21 = fb.get(); m31 = fb.get();
      m02 = fb.get(); m12 = fb.get(); m22 = fb.get(); m32 = fb.get();
      m03 = fb.get(); m13 = fb.get(); m23 = fb.get(); m33 = fb.get();
    } else {
      m00 = fb.get(); m01 = fb.get(); m02 = fb.get(); m03 = fb.get();
      m10 = fb.get(); m11 = fb.get(); m12 = fb.get(); m13 = fb.get();
      m20 = fb.get(); m21 = fb.get(); m22 = fb.get(); m23 = fb.get();
      m30 = fb.get(); m31 = fb.get(); m32 = fb.get(); m33 = fb.get();
    }
      return this;
  }
  */

  /**
   * Legacy wrapper.
   * This name implies that an identity matrix is "loaded", but one is not.
   * Instead, the elements of 'this' identity are set.
   */
  public function loadIdentity() : Void
  {
    setIdentity();
  }

  /**
   * Sets this matrix to the identity matrix,
   * namely all zeros with ones along the diagonal.
   *  
   */
  public function setIdentity() : Void
  {
    m01 = m02 = m03 = m10 = m12 = m13
        = m20 = m21 = m23 = m30 = m31 = m32 = 0.0;
    m00 = m11 = m22 = m33 = 1.0;
  }

  /**
   * <code>fromAngleAxis</code> sets this matrix4f to the values specified
   * by an angle and an axis of rotation.  This method creates an object, so
   * use fromAngleNormalAxis if your axis is already normalized.
   * 
   * @param angle
   *            the angle to rotate (in radians).
   * @param axis
   *            the axis of rotation.
   */
  public function fromAngleAxis(angle : Float, axis : Vector3f) : Void
  {
    var normAxis = axis.normalize();
    fromAngleNormalAxis(angle, normAxis);
  }

  /**
   * <code>fromAngleNormalAxis</code> sets this matrix4f to the values
   * specified by an angle and a normalized axis of rotation.
   * 
   * @param angle
   *            the angle to rotate (in radians).
   * @param axis
   *            the axis of rotation (already normalized).
   */
  public function fromAngleNormalAxis(angle : Float, axis : Vector3f) : Void
  {
    zero();
    m33 = 1.0;

    var fCos = Math.cos(angle);
    var fSin = Math.sin(angle);
    var fOneMinusCos = 1.0-fCos;
    var fX2 = axis.x*axis.x;
    var fY2 = axis.y*axis.y;
    var fZ2 = axis.z*axis.z;
    var fXYM = axis.x*axis.y*fOneMinusCos;
    var fXZM = axis.x*axis.z*fOneMinusCos;
    var fYZM = axis.y*axis.z*fOneMinusCos;
    var fXSin = axis.x*fSin;
    var fYSin = axis.y*fSin;
    var fZSin = axis.z*fSin;
    
    m00 = fX2*fOneMinusCos+fCos;
    m01 = fXYM-fZSin;
    m02 = fXZM+fYSin;
    m10 = fXYM+fZSin;
    m11 = fY2*fOneMinusCos+fCos;
    m12 = fYZM-fXSin;
    m20 = fXZM-fYSin;
    m21 = fYZM+fXSin;
    m22 = fZ2*fOneMinusCos+fCos;
  }

  /**
   * <code>mult</code> multiplies this matrix by a scalar.
   * 
   * @param scalar
   *            the scalar to multiply this matrix by.
   */
  public function multScalarLocal(scalar : Float) : Void
  {
    m00 *= scalar;
    m01 *= scalar;
    m02 *= scalar;
    m03 *= scalar;
    m10 *= scalar;
    m11 *= scalar;
    m12 *= scalar;
    m13 *= scalar;
    m20 *= scalar;
    m21 *= scalar;
    m22 *= scalar;
    m23 *= scalar;
    m30 *= scalar;
    m31 *= scalar;
    m32 *= scalar;
    m33 *= scalar;
  }
  
  public function multScalar(scalar : Float) : Matrix4f
  {
    var out = new Matrix4f();
    out.copy(this);
    out.multScalarLocal(scalar);
    return out;
  }
  
  public function multScalarStore(scalar : Float, store : Matrix4f) : Matrix4f
  {
    store.copy(this);
    store.multScalarLocal(scalar);
    return store;
  }

  /**
   * <code>mult</code> multiplies this matrix with another matrix. The
   * result matrix will then be returned. This matrix will be on the left hand
   * side, while the parameter matrix will be on the right.
   * 
   * @param in2
   *            the matrix to multiply this matrix by.
   * @return the resultant matrix
   */
  public function mult(in2 : Matrix4f) : Matrix4f
  {
    return multStore(in2, null);
  }

  /**
   * <code>mult</code> multiplies this matrix with another matrix. The
   * result matrix will then be returned. This matrix will be on the left hand
   * side, while the parameter matrix will be on the right.
   * 
   * @param in2
   *            the matrix to multiply this matrix by.
   * @param store
   *            where to store the result. It is safe for in2 and store to be
   *            the same object.
   * @return the resultant matrix
   */
  public function multStore(in2 : Matrix4f, store : Matrix4f) : Matrix4f
  {
    if (store == null) store = new Matrix4f();

    // karg: pushing variables on the stack doesn't seem the optimal way of doing this...

    store.m00 = m00 * in2.m00 + 
            m01 * in2.m10 + 
            m02 * in2.m20 + 
            m03 * in2.m30;
    store.m01 = m00 * in2.m01 + 
            m01 * in2.m11 + 
            m02 * in2.m21 +
            m03 * in2.m31;
    store.m02 = m00 * in2.m02 + 
            m01 * in2.m12 + 
            m02 * in2.m22 +
            m03 * in2.m32;
    store.m03 = m00 * in2.m03 + 
            m01 * in2.m13 + 
            m02 * in2.m23 + 
            m03 * in2.m33;
    
    store.m10 = m10 * in2.m00 + 
            m11 * in2.m10 + 
            m12 * in2.m20 +
            m13 * in2.m30;
    store.m11 = m10 * in2.m01 +
            m11 * in2.m11 +
            m12 * in2.m21 +
            m13 * in2.m31;
    store.m12 = m10 * in2.m02 +
            m11 * in2.m12 + 
            m12 * in2.m22 +
            m13 * in2.m32;
    store.m13 = m10 * in2.m03 +
            m11 * in2.m13 +
            m12 * in2.m23 + 
            m13 * in2.m33;

    store.m20 = m20 * in2.m00 + 
            m21 * in2.m10 + 
            m22 * in2.m20 +
            m23 * in2.m30;
    store.m21 = m20 * in2.m01 + 
            m21 * in2.m11 + 
            m22 * in2.m21 +
            m23 * in2.m31;
    store.m22 = m20 * in2.m02 + 
            m21 * in2.m12 + 
            m22 * in2.m22 +
            m23 * in2.m32;
    store.m23 = m20 * in2.m03 + 
            m21 * in2.m13 + 
            m22 * in2.m23 +
            m23 * in2.m33;

    store.m30 = m30 * in2.m00 + 
            m31 * in2.m10 + 
            m32 * in2.m20 +
            m33 * in2.m30;
    store.m31 = m30 * in2.m01 + 
            m31 * in2.m11 + 
            m32 * in2.m21 +
            m33 * in2.m31;
    store.m32 = m30 * in2.m02 + 
            m31 * in2.m12 + 
            m32 * in2.m22 +
            m33 * in2.m32;
    store.m33 = m30 * in2.m03 + 
            m31 * in2.m13 + 
            m32 * in2.m23 +
            m33 * in2.m33;
    
    //store.m00 = temp00;  store.m01 = temp01;  store.m02 = temp02;  store.m03 = temp03;
    //store.m10 = temp10;  store.m11 = temp11;  store.m12 = temp12;  store.m13 = temp13;
    //store.m20 = temp20;  store.m21 = temp21;  store.m22 = temp22;  store.m23 = temp23;
    //store.m30 = temp30;  store.m31 = temp31;  store.m32 = temp32;  store.m33 = temp33;
    
    return store;
  }

  /**
   * <code>mult</code> multiplies this matrix with another matrix. The
   * results are stored internally and a handle to this matrix will 
   * then be returned. This matrix will be on the left hand
   * side, while the parameter matrix will be on the right.
   * 
   * @param in2
   *            the matrix to multiply this matrix by.
   * @return the resultant matrix
   */
  public function multLocal(in2 : Matrix4f) : Matrix4f
  {        
    return multStore(in2, this);
  }

  /**
   * <code>mult</code> multiplies a vector about a rotation matrix. The
   * resulting vector is returned as a new Vector3f.
   * 
   * @param vec
   *            vec to multiply against.
   * @return the rotated vector.
   */
  public function multVector(vec : Vector3f) : Vector3f
  {
    return multVectorStore(vec, null);
  }

  /**
   * <code>mult</code> multiplies a vector about a rotation matrix and adds
   * translation. The resulting vector is returned.
   * 
   * @param vec
   *            vec to multiply against.
   * @param store
   *            a vector to store the result in. Created if null is passed.
   * @return the rotated vector.
   */
  public function multVectorStore(vec : Vector3f, store : Vector3f) : Vector3f
  {
    if (store == null) store = new Vector3f();
    
    var vx = vec.x; 
    var vy = vec.y; 
    var vz = vec.z;

    store.x = m00 * vx + m01 * vy + m02 * vz + m03;
    store.y = m10 * vx + m11 * vy + m12 * vz + m13;
    store.z = m20 * vx + m21 * vy + m22 * vz + m23;

    return store;
  }

  /**
   * <code>mult</code> multiplies a vector about a rotation matrix. The
   * resulting vector is returned.
   * 
   * @param vec
   *            vec to multiply against.
   * @param store
   *            a vector to store the result in.  created if null is passed.
   * @return the rotated vector.
   */
  public function multAcross(vec : Vector3f, store : Vector3f) : Vector3f
  {
    if (null == vec) 
    {
      trace("Warning: Source vector is null, null result returned.");
      return null;
    }

    if (store == null) store = new Vector3f();
    
    var vx = vec.x;
    var vy = vec.y; 
    var vz = vec.z;

    store.x = m00 * vx + m10 * vy + m20 * vz + m30 * 1;
    store.y = m01 * vx + m11 * vy + m21 * vz + m31 * 1;
    store.z = m02 * vx + m12 * vy + m22 * vz + m32 * 1;

    return store;
  }

  /**
   * <code>mult</code> multiplies a quaternion about a matrix. The
   * resulting vector is returned.
   *
   * @param vec
   *            vec to multiply against.
   * @param store
   *            a quaternion to store the result in.  created if null is passed.
   * @return store = this * vec
   */
  public function multQuaternionStore(vec : Quaternion, store : Quaternion) : Quaternion
  {
    if (null == vec) 
    {
      trace("Source vector is null, null result returned.");
      return null;
    }

    if (store == null) store = new Quaternion();

    var x = m00 * vec.x + m10 * vec.y + m20 * vec.z + m30 * vec.w;
    var y = m01 * vec.x + m11 * vec.y + m21 * vec.z + m31 * vec.w;
    var z = m02 * vec.x + m12 * vec.y + m22 * vec.z + m32 * vec.w;
    var w = m03 * vec.x + m13 * vec.y + m23 * vec.z + m33 * vec.w;

    store.x = x;
    store.y = y;
    store.z = z;
    store.w = w;

    return store;
  }
  
  /**
   * <code>mult</code> multiplies an array of 4 floats against this rotation 
   * matrix. The results are stored directly in the array. (vec4f x mat4f)
   * 
   * @param vec4f
   *            float array (size 4) to multiply against the matrix.
   * @return the vec4f for chaining.
   */
  public function multArray(vec4f : Array<Float>) : Array<Float>
  {
    if (null == vec4f || vec4f.length != 4) 
    {
      trace("Warning: invalid array given, must be nonnull and length 4");
      return null;
    }

    var x = vec4f[0];
    var y = vec4f[1];
    var z = vec4f[2]; 
    var w = vec4f[3];
    
    vec4f[0] = m00 * x + m01 * y + m02 * z + m03 * w;
    vec4f[1] = m10 * x + m11 * y + m12 * z + m13 * w;
    vec4f[2] = m20 * x + m21 * y + m22 * z + m23 * w;
    vec4f[3] = m30 * x + m31 * y + m32 * z + m33 * w;

    return vec4f;
  }

  /**
   * <code>mult</code> multiplies an array of 4 floats against this rotation 
   * matrix. The results are stored directly in the array. (vec4f x mat4f)
   * 
   * @param vec4f
   *            float array (size 4) to multiply against the matrix.
   * @return the vec4f for chaining.
   */
  public function multAcrossArray(vec4f : Array<Float>) : Array<Float> 
  {
    if (null == vec4f || vec4f.length != 4) 
    {
      trace("Warning: invalid array given, must be nonnull and length 4");
      return null;
    }

    var x = vec4f[0];
    var y = vec4f[1]; 
    var z = vec4f[2];
    var w = vec4f[3];
    
    vec4f[0] = m00 * x + m10 * y + m20 * z + m30 * w;
    vec4f[1] = m01 * x + m11 * y + m21 * z + m31 * w;
    vec4f[2] = m02 * x + m12 * y + m22 * z + m32 * w;
    vec4f[3] = m03 * x + m13 * y + m23 * z + m33 * w;

    return vec4f;
  }

  /**
   * Inverts this matrix as a new Matrix4f.
   * 
   * @return The new inverse matrix
   */
  public function invert() : Matrix4f
  {
    return invertStore(null);
  }

  /**
   * Inverts this matrix and stores it in the given store.
   * 
   * @return The store
   */
  public function invertStore(store : Matrix4f) : Matrix4f
  {
    if (store == null) store = new Matrix4f();

    var fA0 = m00*m11 - m01*m10;
    var fA1 = m00*m12 - m02*m10;
    var fA2 = m00*m13 - m03*m10;
    var fA3 = m01*m12 - m02*m11;
    var fA4 = m01*m13 - m03*m11;
    var fA5 = m02*m13 - m03*m12;
    var fB0 = m20*m31 - m21*m30;
    var fB1 = m20*m32 - m22*m30;
    var fB2 = m20*m33 - m23*m30;
    var fB3 = m21*m32 - m22*m31;
    var fB4 = m21*m33 - m23*m31;
    var fB5 = m22*m33 - m23*m32;
    var fDet = fA0*fB5-fA1*fB4+fA2*fB3+fA3*fB2-fA4*fB1+fA5*fB0;

    if ( Math.abs(fDet) <= 0 )
        return store.zero();

    store.m00 =   m11*fB5 - m12*fB4 + m13*fB3;
    store.m10 = - m10*fB5 + m12*fB2 - m13*fB1;
    store.m20 =   m10*fB4 - m11*fB2 + m13*fB0;
    store.m30 = - m10*fB3 + m11*fB1 - m12*fB0;
    store.m01 = - m01*fB5 + m02*fB4 - m03*fB3;
    store.m11 =   m00*fB5 - m02*fB2 + m03*fB1;
    store.m21 = - m00*fB4 + m01*fB2 - m03*fB0;
    store.m31 =   m00*fB3 - m01*fB1 + m02*fB0;
    store.m02 =   m31*fA5 - m32*fA4 + m33*fA3;
    store.m12 = - m30*fA5 + m32*fA2 - m33*fA1;
    store.m22 =   m30*fA4 - m31*fA2 + m33*fA0;
    store.m32 = - m30*fA3 + m31*fA1 - m32*fA0;
    store.m03 = - m21*fA5 + m22*fA4 - m23*fA3;
    store.m13 =   m20*fA5 - m22*fA2 + m23*fA1;
    store.m23 = - m20*fA4 + m21*fA2 - m23*fA0;
    store.m33 =   m20*fA3 - m21*fA1 + m22*fA0;

    var fInvDet = 1.0/fDet;
    store.multScalarLocal(fInvDet);

    return store;
  }

  /**
   * Inverts this matrix locally.
   * 
   * @return this
   */
  public function invertLocal() : Matrix4f
  {
    var fA0 = m00*m11 - m01*m10;
    var fA1 = m00*m12 - m02*m10;
    var fA2 = m00*m13 - m03*m10;
    var fA3 = m01*m12 - m02*m11;
    var fA4 = m01*m13 - m03*m11;
    var fA5 = m02*m13 - m03*m12;
    var fB0 = m20*m31 - m21*m30;
    var fB1 = m20*m32 - m22*m30;
    var fB2 = m20*m33 - m23*m30;
    var fB3 = m21*m32 - m22*m31;
    var fB4 = m21*m33 - m23*m31;
    var fB5 = m22*m33 - m23*m32;
    var fDet = fA0*fB5-fA1*fB4+fA2*fB3+fA3*fB2-fA4*fB1+fA5*fB0;

    if ( Math.abs(fDet) <= 1.1920928955078125E-7)
    {
      return zero();
    }

    var f00 =   m11*fB5 - m12*fB4 + m13*fB3;
    var f10 = - m10*fB5 + m12*fB2 - m13*fB1;
    var f20 =   m10*fB4 - m11*fB2 + m13*fB0;
    var f30 = - m10*fB3 + m11*fB1 - m12*fB0;
    var f01 = - m01*fB5 + m02*fB4 - m03*fB3;
    var f11 =   m00*fB5 - m02*fB2 + m03*fB1;
    var f21 = - m00*fB4 + m01*fB2 - m03*fB0;
    var f31 =   m00*fB3 - m01*fB1 + m02*fB0;
    var f02 =   m31*fA5 - m32*fA4 + m33*fA3;
    var f12 = - m30*fA5 + m32*fA2 - m33*fA1;
    var f22 =   m30*fA4 - m31*fA2 + m33*fA0;
    var f32 = - m30*fA3 + m31*fA1 - m32*fA0;
    var f03 = - m21*fA5 + m22*fA4 - m23*fA3;
    var f13 =   m20*fA5 - m22*fA2 + m23*fA1;
    var f23 = - m20*fA4 + m21*fA2 - m23*fA0;
    var f33 =   m20*fA3 - m21*fA1 + m22*fA0;
    
    m00 = f00;
    m01 = f01;
    m02 = f02;
    m03 = f03;
    m10 = f10;
    m11 = f11;
    m12 = f12;
    m13 = f13;
    m20 = f20;
    m21 = f21;
    m22 = f22;
    m23 = f23;
    m30 = f30;
    m31 = f31;
    m32 = f32;
    m33 = f33;

    var fInvDet = 1.0/fDet;
    multScalarLocal(fInvDet);

    return this;
  }
  
  /**
   * Returns a new matrix representing the adjoint of this matrix.
   * 
   * @return The adjoint matrix
   */
  public function adjoint() : Matrix4f
  {
    return adjointStore(null);
  }
   
  
  /**
   * Places the adjoint of this matrix in store (creates store if null.)
   * 
   * @param store
   *            The matrix to store the result in.  If null, a new matrix is created.
   * @return store
   */
  public function adjointStore(store : Matrix4f) : Matrix4f
  {
    if (store == null) store = new Matrix4f();

    var fA0 = m00*m11 - m01*m10;
    var fA1 = m00*m12 - m02*m10;
    var fA2 = m00*m13 - m03*m10;
    var fA3 = m01*m12 - m02*m11;
    var fA4 = m01*m13 - m03*m11;
    var fA5 = m02*m13 - m03*m12;
    var fB0 = m20*m31 - m21*m30;
    var fB1 = m20*m32 - m22*m30;
    var fB2 = m20*m33 - m23*m30;
    var fB3 = m21*m32 - m22*m31;
    var fB4 = m21*m33 - m23*m31;
    var fB5 = m22*m33 - m23*m32;

    store.m00 =   m11*fB5 - m12*fB4 + m13*fB3;
    store.m10 = - m10*fB5 + m12*fB2 - m13*fB1;
    store.m20 =   m10*fB4 - m11*fB2 + m13*fB0;
    store.m30 = - m10*fB3 + m11*fB1 - m12*fB0;
    store.m01 = - m01*fB5 + m02*fB4 - m03*fB3;
    store.m11 =   m00*fB5 - m02*fB2 + m03*fB1;
    store.m21 = - m00*fB4 + m01*fB2 - m03*fB0;
    store.m31 =   m00*fB3 - m01*fB1 + m02*fB0;
    store.m02 =   m31*fA5 - m32*fA4 + m33*fA3;
    store.m12 = - m30*fA5 + m32*fA2 - m33*fA1;
    store.m22 =   m30*fA4 - m31*fA2 + m33*fA0;
    store.m32 = - m30*fA3 + m31*fA1 - m32*fA0;
    store.m03 = - m21*fA5 + m22*fA4 - m23*fA3;
    store.m13 =   m20*fA5 - m22*fA2 + m23*fA1;
    store.m23 = - m20*fA4 + m21*fA2 - m23*fA0;
    store.m33 =   m20*fA3 - m21*fA1 + m22*fA0;

    return store;
  }

  /**
   * <code>determinant</code> generates the determinate of this matrix.
   * 
   * @return the determinate
   */
  public function determinant() : Float
  {
      var fA0 = m00*m11 - m01*m10;
      var fA1 = m00*m12 - m02*m10;
      var fA2 = m00*m13 - m03*m10;
      var fA3 = m01*m12 - m02*m11;
      var fA4 = m01*m13 - m03*m11;
      var fA5 = m02*m13 - m03*m12;
      var fB0 = m20*m31 - m21*m30;
      var fB1 = m20*m32 - m22*m30;
      var fB2 = m20*m33 - m23*m30;
      var fB3 = m21*m32 - m22*m31;
      var fB4 = m21*m33 - m23*m31;
      var fB5 = m22*m33 - m23*m32;
      var fDet = fA0*fB5-fA1*fB4+fA2*fB3+fA3*fB2-fA4*fB1+fA5*fB0;
      return fDet;
  }

  /**
   * Sets all of the values in this matrix to zero.
   * 
   * @return this matrix
   */
  public function zero() : Matrix4f
  {
      m00 = m01 = m02 = m03 = m10 = m11 = m12 = m13 
        = m20 = m21 = m22 = m23 = m30 = m31 = m32 = m33 = 0.0;
      return this;
  }
  
  public function add(mat : Matrix4f) : Matrix4f
  {
    var result = new Matrix4f();
    result.m00 = this.m00 + mat.m00;
    result.m01 = this.m01 + mat.m01;
    result.m02 = this.m02 + mat.m02;
    result.m03 = this.m03 + mat.m03;
    result.m10 = this.m10 + mat.m10;
    result.m11 = this.m11 + mat.m11;
    result.m12 = this.m12 + mat.m12;
    result.m13 = this.m13 + mat.m13;
    result.m20 = this.m20 + mat.m20;
    result.m21 = this.m21 + mat.m21;
    result.m22 = this.m22 + mat.m22;
    result.m23 = this.m23 + mat.m23;
    result.m30 = this.m30 + mat.m30;
    result.m31 = this.m31 + mat.m31;
    result.m32 = this.m32 + mat.m32;
    result.m33 = this.m33 + mat.m33;
    return result;
  }

  /**
   * <code>add</code> adds the values of a parameter matrix to this matrix.
   * 
   * @param mat
   *            the matrix to add to this.
   */
  public function addLocal(mat : Matrix4f) : Void
  {
    m00 += mat.m00;
    m01 += mat.m01;
    m02 += mat.m02;
    m03 += mat.m03;
    m10 += mat.m10;
    m11 += mat.m11;
    m12 += mat.m12;
    m13 += mat.m13;
    m20 += mat.m20;
    m21 += mat.m21;
    m22 += mat.m22;
    m23 += mat.m23;
    m30 += mat.m30;
    m31 += mat.m31;
    m32 += mat.m32;
    m33 += mat.m33;
  }
  
  public function toTranslationVector() : Vector3f
  {
    return new Vector3f(m03, m13, m23);
  }
  
  public function toTranslationVectorStore(vector : Vector3f) : Void
  {
    vector.set(m03, m13, m23);
  }
  
  public function toRotationQuat() : Quaternion
  {
    var quat = new Quaternion();
    quat.fromRotationMatrix(toRotationMatrix());
    return quat;
  }
  
  public function toRotationQuatStore(q : Quaternion) : Void
  {
    q.fromRotationMatrix(toRotationMatrix());
  }
  
  public function toRotationMatrix() : Matrix3f
  {
    var m = new Matrix3f(); 
    
    m.m00 = m00;
    m.m01 = m01;
    m.m02 = m02;
    m.m10 = m10;
    m.m11 = m11;
    m.m12 = m12;
    m.m02 = m20;
    m.m12 = m21;
    m.m22 = m22;

    return m;
  }
  
  public function toRotationMatrixStore(mat : Matrix3f) : Void
  {
    mat.m00 = m00;
    mat.m01 = m01;
    mat.m02 = m02;
    mat.m10 = m10;
    mat.m11 = m11;
    mat.m12 = m12;
    mat.m20 = m20;
    mat.m21 = m21;
    mat.m22 = m22;        
  }

  /**
   * <code>setTranslation</code> will set the matrix's translation values.
   * 
   * @param translation
   *            the new values for the translation.
   * @throws JmeException
   *             if translation is not size 3.
   */
  public function setTranslationFromArray(translation : Array<Float>) : Void
  {
    if (translation.length != 3) 
    { 
      throw ("Translation size must be 3."); 
    }

    m03 = translation[0];
    m13 = translation[1];
    m23 = translation[2];
  }

  /**
   * <code>setTranslation</code> will set the matrix's translation values.
   * 
   * @param x
   *            value of the translation on the x axis
   * @param y
   *            value of the translation on the y axis
   * @param z
   *            value of the translation on the z axis
   */
  public function setTranslation(x : Float, y : Float, z : Float) 
  {
    m03 = x;
    m13 = y;
    m23 = z;
  }

  /**
   * <code>setTranslation</code> will set the matrix's translation values.
   *
   * @param translation
   *            the new values for the translation.
   */
  public function setTranslationVector3f(translation : Vector3f) : Void
  {
    m03 = translation.x;
    m13 = translation.y;
    m23 = translation.z;
  }

  /**
   * <code>setInverseTranslation</code> will set the matrix's inverse
   * translation values.
   * 
   * @param translation
   *            the new values for the inverse translation.
   * @throws JmeException
   *             if translation is not size 3.
   */
  public function setInverseTranslation(translation : Array<Float>) : Void
  {
    if (translation.length != 3) 
    { 
      throw ("Translation size must be 3."); 
    }

    m03 = -translation[0];
    m13 = -translation[1];
    m23 = -translation[2];
  }

  /**
   * <code>angleRotation</code> sets this matrix to that of a rotation about
   * three axes (x, y, z). Where each axis has a specified rotation in
   * degrees. These rotations are expressed in a single <code>Vector3f</code>
   * object.
   * 
   * @param angles
   *            the angles in degree to rotate.
   */
  public function angleRotation(angles : Vector3f) : Void
  {
    var angle = (angles.z * MathEx.DEG_TO_RAD());
    var sy = Math.sin(angle);
    var cy = Math.cos(angle);

    angle = (angles.y * MathEx.DEG_TO_RAD());
    var sp = Math.sin(angle);
    var cp = Math.cos(angle);

    angle = (angles.x * MathEx.DEG_TO_RAD());
    var sr = Math.sin(angle);
    var cr = Math.cos(angle);

    // matrix = (Z * Y) * X
    m00 = cp * cy;
    m10 = cp * sy;
    m20 = -sp;
    m01 = sr * sp * cy + cr * -sy;
    m11 = sr * sp * sy + cr * cy;
    m21 = sr * cp;
    m02 = (cr * sp * cy + -sr * -sy);
    m12 = (cr * sp * sy + -sr * cy);
    m22 = cr * cp;
    m03 = 0.0;
    m13 = 0.0;
    m23 = 0.0;
  }

  /**
   * <code>setRotationQuaternion</code> builds a rotation from a
   * <code>Quaternion</code>.
   * 
   * @param quat
   *            the quaternion to build the rotation from.
   * @throws NullPointerException
   *             if quat is null.
   */
  public function setRotationQuaternion(quat : Quaternion) : Void
  {
    quat.toRotationMatrix4Store(this);
  }

  /**
   * <code>setInverseRotationRadians</code> builds an inverted rotation from
   * Euler angles that are in radians.
   * 
   * @param angles
   *            the Euler angles in radians.
   * @throws JmeException
   *             if angles is not size 3.
   */
  public function setInverseRotationRadians(angles : Array<Float>) : Void 
  {
    if (angles.length != 3) 
    { 
      throw ("Angles must be of size 3."); 
    }

    var cr = Math.cos(angles[0]);
    var sr = Math.sin(angles[0]);
    var cp = Math.cos(angles[1]);
    var sp = Math.sin(angles[1]);
    var cy = Math.cos(angles[2]);
    var sy = Math.sin(angles[2]);

    m00 = (cp * cy);
    m10 = (cp * sy);
    m20 = (-sp);

    var srsp = sr * sp;
    var crsp = cr * sp;

    m01 = (srsp * cy - cr * sy);
    m11 = (srsp * sy + cr * cy);
    m21 = (sr * cp);

    m02 = (crsp * cy + sr * sy);
    m12 = (crsp * sy - sr * cy);
    m22 = (cr * cp);
  }

  /**
   * <code>setInverseRotationDegrees</code> builds an inverted rotation from
   * Euler angles that are in degrees.
   * 
   * @param angles
   *            the Euler angles in degrees.
   * @throws JmeException
   *             if angles is not size 3.
   */
  public function setInverseRotationDegrees(angles : Array<Float>) : Void
  {
    if (angles.length != 3) 
    { 
      throw ("Angles must be of size 3."); 
    }

    var vec = new Array<Float>();

    vec.push(angles[0] * MathEx.RAD_TO_DEG());
    vec.push(angles[1] * MathEx.RAD_TO_DEG());
    vec.push(angles[2] * MathEx.RAD_TO_DEG());
    setInverseRotationRadians(vec);
  }

  /**
   * 
   * <code>inverseTranslateVect</code> translates a given Vector3f by the
   * translation part of this matrix.
   * 
   * @param vec
   *            the Vector3f data to be translated.
   * @throws JmeException
   *             if the size of the Vector3f is not 3.
   */
  public function inverseTranslateVectArray(vec : Array<Float>) : Void
  {
    if (vec.length != 3) 
    { 
      throw ("vec must be of size 3."); 
    }

    vec[0] = vec[0] - m03;
    vec[1] = vec[1] - m13;
    vec[2] = vec[2] - m23;
  }

  /**
   * 
   * <code>inverseTranslateVect</code> translates a given Vector3f by the
   * translation part of this matrix.
   * 
   * @param data
   *            the Vector3f to be translated.
   * @throws JmeException
   *             if the size of the Vector3f is not 3.
   */
  public function inverseTranslateVect(data : Vector3f) : Void
  {
    data.x -= m03;
    data.y -= m13;
    data.z -= m23;
  }

  /**
   * 
   * <code>inverseTranslateVect</code> translates a given Vector3f by the
   * translation part of this matrix.
   * 
   * @param data
   *            the Vector3f to be translated.
   * @throws JmeException
   *             if the size of the Vector3f is not 3.
   */
  public function translateVect(data : Vector3f) : Void
  {
    data.x += m03;
    data.y += m13;
    data.z += m23;
  }

  /**
   * 
   * <code>inverseRotateVect</code> rotates a given Vector3f by the rotation
   * part of this matrix.
   * 
   * @param vec
   *            the Vector3f to be rotated.
   */
  public function inverseRotateVect(vec : Vector3f) : Void
  {
    var vx = vec.x;
    var vy = vec.y;
    var vz = vec.z;

    vec.x = vx * m00 + vy * m10 + vz * m20;
    vec.y = vx * m01 + vy * m11 + vz * m21;
    vec.z = vx * m02 + vy * m12 + vz * m22;
  }
  
  public function rotateVect(vec : Vector3f) : Void
  {
    var vx = vec.x;
    var vy = vec.y;
    var vz = vec.z;

    vec.x = vx * m00 + vy * m01 + vz * m02;
    vec.y = vx * m10 + vy * m11 + vz * m12;
    vec.z = vx * m20 + vy * m21 + vz * m22;
  }

  /**
   * <code>toString</code> returns the string representation of this object.
   * It is in a format of a 4x4 matrix. For example, an identity matrix would
   * be represented by the following string. com.jme.math.Matrix3f <br>[<br>
   * 1.0  0.0  0.0  0.0 <br>
   * 0.0  1.0  0.0  0.0 <br>
   * 0.0  0.0  1.0  0.0 <br>
   * 0.0  0.0  0.0  1.0 <br>]<br>
   * 
   * @return the string representation of this object.
   */
  public function toString() : String
  {
    return 
      m00 + " " + m01 + " " + m02 + " " + m03 + "\n" +
      m10 + " " + m11 + " " + m12 + " " + m13 + "\n" +
      m20 + " " + m21 + " " + m22 + " " + m23 + "\n" +
      m30 + " " + m31 + " " + m32 + " " + m33;
  }

  /**
   * 
   * <code>hashCode</code> returns the hash code value as an integer and is
   * supported for the benefit of hashing based collection classes such as
   * Hashtable, HashMap, HashSet etc.
   * 
   * @return the hashcode for this instance of Matrix4f.
   * @see java.lang.Object#hashCode()
   */
   /*
  public int hashCode() {
      int hash = 37;
      hash = 37 * hash + Float.floatToIntBits(m00);
      hash = 37 * hash + Float.floatToIntBits(m01);
      hash = 37 * hash + Float.floatToIntBits(m02);
      hash = 37 * hash + Float.floatToIntBits(m03);

      hash = 37 * hash + Float.floatToIntBits(m10);
      hash = 37 * hash + Float.floatToIntBits(m11);
      hash = 37 * hash + Float.floatToIntBits(m12);
      hash = 37 * hash + Float.floatToIntBits(m13);

      hash = 37 * hash + Float.floatToIntBits(m20);
      hash = 37 * hash + Float.floatToIntBits(m21);
      hash = 37 * hash + Float.floatToIntBits(m22);
      hash = 37 * hash + Float.floatToIntBits(m23);

      hash = 37 * hash + Float.floatToIntBits(m30);
      hash = 37 * hash + Float.floatToIntBits(m31);
      hash = 37 * hash + Float.floatToIntBits(m32);
      hash = 37 * hash + Float.floatToIntBits(m33);

      return hash;
  }
  */
  
  /**
   * are these two matrices the same? they are is they both have the same mXX values.
   *
   * @param o
   *            the object to compare for equality
   * @return true if they are equal
   */
  public function equals(m : Matrix4f) : Bool
  {
    return 
      (m00 == m.m00) && (m01 == m.m01) && (m02 == m.m02) && (m03 == m.m03) &&
      (m10 == m.m10) && (m11 == m.m11) && (m12 == m.m12) && (m13 == m.m13) &&
      (m20 == m.m20) && (m21 == m.m21) && (m22 == m.m22) && (m23 == m.m23) &&
      (m30 == m.m30) && (m31 == m.m31) && (m32 == m.m32) && (m33 == m.m33);
  }

  /**
   * @return true if this matrix is identity
   */
  public function isIdentity() : Bool
  {
      return 
      (m00 == 1 && m01 == 0 && m02 == 0 && m03 == 0) &&
      (m10 == 0 && m11 == 1 && m12 == 0 && m13 == 0) &&
      (m20 == 0 && m21 == 0 && m22 == 1 && m23 == 0) &&
      (m30 == 0 && m31 == 0 && m32 == 0 && m33 == 1);
  }

  /**
   * Apply a scale to this matrix.
   * 
   * @param scale
   *            the scale to apply
   */
  public function scale(scale : Vector3f) : Void
  {
    m00 *= scale.x;
    m10 *= scale.x;
    m20 *= scale.x;
    m30 *= scale.x;
    m01 *= scale.y;
    m11 *= scale.y;
    m21 *= scale.y;
    m31 *= scale.y;
    m02 *= scale.z;
    m12 *= scale.z;
    m22 *= scale.z;
    m32 *= scale.z;
  }

  public static function equalIdentity(mat : Matrix4f) : Bool
  {
    if (Math.abs(mat.m00 - 1) > 1e-4) return false;
    if (Math.abs(mat.m11 - 1) > 1e-4) return false;
    if (Math.abs(mat.m22 - 1) > 1e-4) return false;
    if (Math.abs(mat.m33 - 1) > 1e-4) return false;

    if (Math.abs(mat.m01) > 1e-4) return false;
    if (Math.abs(mat.m02) > 1e-4) return false;
    if (Math.abs(mat.m03) > 1e-4) return false;

    if (Math.abs(mat.m10) > 1e-4) return false;
    if (Math.abs(mat.m12) > 1e-4) return false;
    if (Math.abs(mat.m13) > 1e-4) return false;

    if (Math.abs(mat.m20) > 1e-4) return false;
    if (Math.abs(mat.m21) > 1e-4) return false;
    if (Math.abs(mat.m23) > 1e-4) return false;

    if (Math.abs(mat.m30) > 1e-4) return false;
    if (Math.abs(mat.m31) > 1e-4) return false;
    if (Math.abs(mat.m32) > 1e-4) return false;

    return true;
  }

  // XXX: This tests more solid than converting the q to a matrix and multiplying... why?
  public function multQuatLocal(rotation : Quaternion) : Void
  {
    var axis = new Vector3f();
    var angle = rotation.toAngleAxis(axis);
    var matrix4f = new Matrix4f();
    matrix4f.fromAngleAxis(angle, axis);
    multLocal(matrix4f);
  }
  
  public function clone() : Matrix4f
  {
    var m = new Matrix4f();

    m.copy(this);

    return m;
  }
}

