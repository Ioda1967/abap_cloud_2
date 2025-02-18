CLASS zael_trial_3 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZAEL_TRIAL_3 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


    DATA var_string TYPE string.
    DATA var_int TYPE i.
    DATA var_date TYPE d.
    DATA var_pack TYPE p LENGTH 3 DECIMALS 2.


    var_string = `12345`.
    var_int = var_string.


    out->write( 'Conversion successful' ).


    var_string = `20230101`.
    var_date = var_string.


    out->write( |String value: { var_string }| ).
    out->write( |Date Value: { var_date DATE = USER }| ).


    DATA long_char TYPE c LENGTH 10.
    DATA short_char TYPE c LENGTH 5.


    DATA result TYPE p LENGTH 3 DECIMALS 2.


    long_char = 'ABCDEFGHIJ'.
    short_char = long_char.


    out->write( long_char ).
    out->write( short_char ).


    result = 1 / 8.
    out->write( |DATA result TYPE p LENGTH 3 DECIMALS 2.| ).
    out->write( |1 / 8 is rounded to { result NUMBER = USER }| ).


    DATA var_n TYPE n LENGTH 4.

    var_date = cl_abap_context_info=>get_system_date( ).
    var_int = var_date.

    out->write( |Date as date| ).
    out->write( var_date ).
    out->write( |Date assigned to integer| ).
    out->write( var_int ).

    out->write( |Transfer characters to a date| ).
    out->write( 'var_date = ABCD' ).
    var_date = 'ABCD'.
    out->write( var_date ).


    var_string = `R2D2`.
    var_n = var_string.

    out->write( |String| ).
    out->write( var_string ).
    out->write( |String assigned to type N| ).
    out->write( var_n ).


    DATA var_char   TYPE c LENGTH 3.

    var_pack = 1 / 8.
    out->write( |1/8 = { var_pack NUMBER = USER }| ).

    TRY.
        var_pack = EXACT #( 1 / 8 ).
      CATCH cx_sy_conversion_error.
        out->write( |1/8 has to be rounded. EXACT triggered an exception| ).
    ENDTRY.

    var_string = 'ABCDE'.
    var_char   = var_string.
    out->write( var_char ).

    TRY.
        var_char = EXACT #( var_string ).
      CATCH cx_sy_conversion_error.
        out->write( 'String has to be truncated. EXACT triggered an exception' ).
    ENDTRY.

    var_date = 'ABCDEFGH'.
    out->write( var_Date ).

    TRY.
        var_date = EXACT #( 'ABCDEFGH' ).
      CATCH cx_sy_conversion_error.
        out->write( |ABCDEFGH is not a valid date. EXACT triggered an exception| ).
    ENDTRY.


    var_date = '20221232'.
    out->write( var_date ).


    TRY.
        var_date = EXACT #( '20221232' ).
      CATCH cx_sy_conversion_error.
        out->write( |2022-12-32 is not a valid date. EXACT triggered an exception| ).
    ENDTRY.


    DATA timestamp1 TYPE utclong.
    DATA timestamp2 TYPE utclong.
    DATA difference TYPE decfloat34.
    DATA date_user TYPE d.
    DATA time_user TYPE t.

    timestamp1 = utclong_current( ).
    out->write( |Current UTC time { timestamp1 }| ).

    timestamp2 = utclong_add( val = timestamp1 days = 7 ).
    out->write( |Added 7 days to current UTC time { timestamp2 }| ).

    difference = utclong_diff( high = timestamp2 low = timestamp1 ).
    out->write( |Difference between timestamps in seconds: { difference }| ).

    out->write( |Difference between timestamps in days: { difference / 3600 / 24 }| ).

    CONVERT UTCLONG utclong_current( )
       INTO DATE date_user
            TIME time_user
            TIME ZONE cl_abap_context_info=>get_user_time_zone( ).

    out->write( |UTC timestamp split into date (type D) and time (type T )| ).
    out->write( |according to the user's time zone (cl_abap_context_info=>get_user_time_zone( ) ).| ).
    out->write( |{ date_user DATE = USER }, { time_user TIME = USER }| ).


  ENDMETHOD.
ENDCLASS.
