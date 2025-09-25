%module(directors="1") csocrstudiosdk
%feature("director") ocrstudio::OCRStudioSDKDelegate;

%include typemaps.i
%include exception.i
%include std_except.i
%include std_map.i
%include std_string.i
%include std_vector.i
%include stdint.i

%{
  #include "ocrstudiosdk/ocr_studio_delegate.h"
  #include "ocrstudiosdk/ocr_studio_exception.h"
  #include "ocrstudiosdk/ocr_studio_export.h"
  #include "ocrstudiosdk/ocr_studio_image.h"
  #include "ocrstudiosdk/ocr_studio_instance.h"
  #include "ocrstudiosdk/ocr_studio_result.h"
  #include "ocrstudiosdk/ocr_studio_session.h"
  #include "ocrstudiosdk/ocr_studio_string.h"
%}

%pragma(csharp) imclassimports=%{
  using ocrstudio;
%}

%include "arrays_csharp.i"
CSHARP_ARRAYS(char, byte)

%apply unsigned char INPUT[] {unsigned char* data};
%apply unsigned char INPUT[] {unsigned char* raw_data};
%apply unsigned char INPUT[] {unsigned char* yuv_data};
%apply unsigned char INPUT[] {unsigned char* y_plane};
%apply unsigned char INPUT[] {unsigned char* u_plane};
%apply unsigned char INPUT[] {unsigned char* v_plane};
%apply unsigned char INPUT[] {unsigned char* configuration_buffer};
%apply unsigned char OUTPUT[] {unsigned char* export_buffer};

%typemap(csimports) SWIGTYPE %{
  using ocrstudio;
%}

%pragma(csharp) imclassimports=%{
using System.Runtime.InteropServices;
using System;
using System.Text;
%}

%pragma(csharp) imclasscode=%{
public class SimpleMarshaler : ICustomMarshaler {
    static SimpleMarshaler myself = new SimpleMarshaler();

    public object MarshalNativeToManaged(IntPtr pNativeData) {
        int size_buffer = 0;
        while (Marshal.ReadByte(pNativeData, size_buffer) != 0) {
            ++size_buffer;
        }
        byte[] byte_buffer = new byte[size_buffer];
        Marshal.Copy((IntPtr)pNativeData, byte_buffer, 0, size_buffer);
        return Encoding.UTF8.GetString(byte_buffer);
    }

    public IntPtr MarshalManagedToNative( Object ManagedObj ) => throw new NotImplementedException();

    public void CleanUpNativeData( IntPtr nativeData ) {
        Marshal.FreeHGlobal(nativeData);
    }

    public void CleanUpManagedData( Object ManagedObj ) => throw new NotImplementedException();
    public int GetNativeDataSize() => throw new NotImplementedException();

    public static ICustomMarshaler GetInstance(string cookie) {
        return myself;
    }
}
%}

%exception {
  try {
    $action
  } catch (const ocrstudio::OCRStudioSDKException& e) {
        SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: ") + std::string(e.Type()) + " exception caught: " + e.Message()).c_str());
        return $null;
  } catch (const std::exception& e) {
        SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), (std::string("CRITICAL!: STL exception caught: ") + e.what()).c_str());
        return $null;
  } catch (...) {
        SWIG_CSharpSetPendingException(static_cast<SWIG_CSharpExceptionCodes>(SWIG_RuntimeError), "CRITICAL!: Unknown exception caught");
        return $null;
  }
}


%newobject ocrstudio::OCRStudioSDKImage::CreateEmpty;
%newobject ocrstudio::OCRStudioSDKImage::CreateFromFile;
%newobject ocrstudio::OCRStudioSDKImage::CreateFromFileBuffer;
%newobject ocrstudio::OCRStudioSDKImage::CreateFromBase64FileBuffer;
%newobject ocrstudio::OCRStudioSDKImage::CreateFromPixelBuffer;
%newobject ocrstudio::OCRStudioSDKImage::CreateFromYUVSimple;
%newobject ocrstudio::OCRStudioSDKImage::CreateFromYUV;
%newobject ocrstudio::OCRStudioSDKImage::DeepCopy;
%newobject ocrstudio::OCRStudioSDKImage::ShallowCopy;
%newobject ocrstudio::OCRStudioSDKImage::DeepCopyScaled;
%newobject ocrstudio::OCRStudioSDKImage::DeepCopyCroppedByQuad;
%newobject ocrstudio::OCRStudioSDKImage::DeepCopyCroppedByRect;
%newobject ocrstudio::OCRStudioSDKImage::ShallowCopyCroppedByRect;
%newobject ocrstudio::OCRStudioSDKImage::DeepCopyRotatedByNinety;

%newobject ocrstudio::OCRStudioSDKInstance::CreateStandalone;
%newobject ocrstudio::OCRStudioSDKInstance::CreateFromPath;
%newobject ocrstudio::OCRStudioSDKInstance::CreateFromBuffer;
%newobject ocrstudio::OCRStudioSDKInstance::CreateSession;

%newobject ocrstudio::OCRStudioSDKTarget::DeepCopy;
%newobject ocrstudio::OCRStudioSDKResult::DeepCopy;

%ignore OCRStudioSDKItemIteratorImplementation;
%ignore ocrstudio::OCRStudioSDKImage::GetUnsafeBufferPtr;
%ignore ocrstudio::OCRStudioSDKImage::UnsafeBufferPtr;
%ignore CreateFromImplementation;

%rename("%(lowercamelcase)s", %$isvariable) "";


%typemap(imtype,
         outattributes="\n  [return: global::System.Runtime.InteropServices.MarshalAs(global::System.Runtime.InteropServices.UnmanagedType.CustomMarshaler, MarshalTypeRef = typeof(SimpleMarshaler))] \n ") const char * "string";
%typemap(imtype) const char *;
%include "ocrstudiosdk/ocr_studio_export.h"
%include "ocrstudiosdk/ocr_studio_exception.h"
%include "ocrstudiosdk/ocr_studio_string.h"
%include "ocrstudiosdk/ocr_studio_delegate.h"
%include "ocrstudiosdk/ocr_studio_image.h"
%include "ocrstudiosdk/ocr_studio_result.h"
%include "ocrstudiosdk/ocr_studio_session.h"
%include "ocrstudiosdk/ocr_studio_instance.h"

%typemap(imtype) const char *;
