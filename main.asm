;*******************************************************************************
;                                                                              *
;    Microchip licenses this software to you solely for use with Microchip     *
;    products. The software is owned by Microchip and/or its licensors, and is *
;    protected under applicable copyright laws.  All rights reserved.          *
;                                                                              *
;    This software and any accompanying information is for suggestion only.    *
;    It shall not be deemed to modify Microchip?s standard warranty for its    *
;    products.  It is your responsibility to ensure that this software meets   *
;    your requirements.                                                        *
;                                                                              *
;    SOFTWARE IS PROVIDED "AS IS".  MICROCHIP AND ITS LICENSORS EXPRESSLY      *
;    DISCLAIM ANY WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING  *
;    BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS    *
;    FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL          *
;    MICROCHIP OR ITS LICENSORS BE LIABLE FOR ANY INCIDENTAL, SPECIAL,         *
;    INDIRECT OR CONSEQUENTIAL DAMAGES, LOST PROFITS OR LOST DATA, HARM TO     *
;    YOUR EQUIPMENT, COST OF PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR    *
;    SERVICES, ANY CLAIMS BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY   *
;    DEFENSE THEREOF), ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER      *
;    SIMILAR COSTS.                                                            *
;                                                                              *
;    To the fullest extend allowed by law, Microchip and its licensors         *
;    liability shall not exceed the amount of fee, if any, that you have paid  *
;    directly to Microchip to use this software.                               *
;                                                                              *
;    MICROCHIP PROVIDES THIS SOFTWARE CONDITIONALLY UPON YOUR ACCEPTANCE OF    *
;    THESE TERMS.                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Filename:                                                                 *
;    Date:                                                                     *
;    File Version:                                                             *
;    Author:                                                                   *
;    Company:                                                                  *
;    Description:                                                              *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Notes: In the MPLAB X Help, refer to the MPASM Assembler documentation    *
;    for information on assembly instructions.                                 *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Known Issues: This template is designed for relocatable code.  As such,   *
;    build errors such as "Directive only allowed when generating an object    *
;    file" will result when the 'Build in Absolute Mode' checkbox is selected  *
;    in the project properties.  Designing code in absolute mode is            *
;    antiquated - use relocatable mode.                                        *
;                                                                              *
;*******************************************************************************
;                                                                              *
;    Revision History:                                                         *
;                                                                              *
;*******************************************************************************



;*******************************************************************************
; Processor Inclusion
;
; TODO Step #1 Open the task list under Window > Tasks.  Include your
; device .inc file - e.g. #include <device_name>.inc.  Available
; include files are in C:\Program Files\Microchip\MPLABX\mpasmx
; assuming the default installation path for MPLAB X.  You may manually find
; the appropriate include file for your device here and include it, or
; simply copy the include generated by the configuration bits
; generator (see Step #2).
;
;*******************************************************************************
#include <p16f690.inc>
; TODO INSERT INCLUDE CODE HERE

;*******************************************************************************
;
; TODO Step #2 - Configuration Word Setup
;
; The 'CONFIG' directive is used to embed the configuration word within the
; .asm file. MPLAB X requires users to embed their configuration words
; into source code.  See the device datasheet for additional information
; on configuration word settings.  Device configuration bits descriptions
; are in C:\Program Files\Microchip\MPLABX\mpasmx\P<device_name>.inc
; (may change depending on your MPLAB X installation directory).
;
; MPLAB X has a feature which generates configuration bits source code.  Go to
; Window > PIC Memory Views > Configuration Bits.  Configure each field as
; needed and select 'Generate Source Code to Output'.  The resulting code which
; appears in the 'Output Window' > 'Config Bits Source' tab may be copied
; below.
;
;*******************************************************************************

; TODO INSERT CONFIG HERE
 __CONFIG _FOSC_INTRCIO & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_NSLEEP & _IESO_OFF & _FCMEN_OFF
;*******************************************************************************
;
; TODO Step #3 - Variable Definitions
;
; Refer to datasheet for available data memory (RAM) organization assuming
; relocatible code organization (which is an option in project
; properties > mpasm (Global Options)).  Absolute mode generally should
; be used sparingly.
;
; Example of using GPR Uninitialized Data
;
;   GPR_VAR        UDATA
;   MYVAR1         RES        1      ; User variable linker places
;   MYVAR2         RES        1      ; User variable linker places
;   MYVAR3         RES        1      ; User variable linker places
;
;   ; Example of using Access Uninitialized Data Section (when available)
;   ; The variables for the context saving in the device datasheet may need
;   ; memory reserved here.
;   INT_VAR        UDATA_ACS
;   W_TEMP         RES        1      ; w register for context saving (ACCESS)
;   STATUS_TEMP    RES        1      ; status used for context saving
;   BSR_TEMP       RES        1      ; bank select used for ISR context saving
;
;*******************************************************************************

; TODO PLACE VARIABLE DEFINITIONS GO HERE
;MYVARS  UDATA
TEMP    EQU 0x7F
FLAGS   EQU 0x7E
BADPWR  EQU 0       ;bit0 bad power V<12
LOWPWR  EQU 1       ;bit1 low power 12<V<13
OVERT   EQU 2       ;bit2 overtemp

;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

;*******************************************************************************
; TODO Step #4 - Interrupt Service Routines
;
; There are a few different ways to structure interrupt routines in the 8
; bit device families.  On PIC18's the high priority and low priority
; interrupts are located at 0x0008 and 0x0018, respectively.  On PIC16's and
; lower the interrupt is at 0x0004.  Between device families there is subtle
; variation in the both the hardware supporting the ISR (for restoring
; interrupt context) as well as the software used to restore the context
; (without corrupting the STATUS bits).
;
; General formats are shown below in relocatible format.
;
;------------------------------PIC16's and below--------------------------------
;
ISR       CODE    0x0004           ; interrupt vector location
;
;     <Search the device datasheet for 'context' and copy interrupt
;     context saving code here.  Older devices need context saving code,
;     but newer devices like the 16F#### don't need context saving code.>
;
     RETFIE
;
;----------------------------------PIC18's--------------------------------------
;
; ISRHV     CODE    0x0008
;     GOTO    HIGH_ISR
; ISRLV     CODE    0x0018
;     GOTO    LOW_ISR
;
; ISRH      CODE                     ; let linker place high ISR routine
; HIGH_ISR
;     <Insert High Priority ISR Here - no SW context saving>
;     RETFIE  FAST
;
; ISRL      CODE                     ; let linker place low ISR routine
; LOW_ISR
;       <Search the device datasheet for 'context' and copy interrupt
;       context saving code here>
;     RETFIE
;
;*******************************************************************************

; TODO INSERT ISR HERE

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE                      ; let linker place main program

GET_ADC
    movwf   ADCON0
    call    RET
    call    RET
    bsf     ADCON0,GO                       ;start convertion
    btfsc   ADCON0,GO
    goto    $-1
RET
    return


START
    ;programming I/O
    bcf     STATUS,RP1
    bsf     STATUS,RP0                      ;set bank 1    
    ;set option reg
    movlw   (1<<PS2)|(1<<PS1)|(1<<PS0)      ;prescaler TMR0 1/256 256us/tick
    movwf   OPTION_REG
    movlw   0x1F
    movwf   PR2                             ;set TMR2 max
    ;set pullups portA
    movlw   (1<<RA3)
    movwf   WPUA
    ;io directions
    movlw   ~((1<<RA0)|(1<<RA1))
    movwf   TRISA
    movlw   ~((1<<RB7)|(1<<RB4))
    movwf   TRISB
    movlw   (1<<RC0)|(1<<RC7)
    movwf   TRISC
    ;WDT
    movlw   (1<<WDTPS3)|(1<<SWDTEN)         ;250ms WDT
    movwf   WDTCON

    bsf     STATUS,RP1                      ;set bank 3

    bcf     STATUS,RP0                      ;set bank 2
    ;analog inputs
    movlw   (1<<ANS4)
    movwf   ANSEL
    movlw   (1<<ANS9)
    movwf   ANSELH
    ;ADC clock set
    movlw   (1<<ADCS2)|(1<<ADCS0)           ;Fosc/16
    movwf   ADCON1

    ;set pullups portB
    movlw   (1<<RB5)|(1<<RB6)
    movwf   WPUB
    clrf    STATUS                          ;clear status, set bank 0
    movlw   (1<<T1CKPS1)|(1<<T1CKPS0)|(1<<TMR1ON)
    movwf   T1CON                           ;8us/tick


MAIN_SLEEP
    clrf    FLAGS
    clrf    CCP1CON                         ;shutdown PWM
    clrf    ADCON0                          ;shutdown ADC
    clrf    PORTA                           
    clrf    PORTB
    movlw   (1<<RC3)|(1<<RC1)|(1<<RC2)
    movwf   PORTC                           ;shutdown PW, SH, LEDS OFF
    clrwdt
    sleep                                   ;sleep 250ms (WDT)
    nop

MAIN_ON
    clrw
    btfss   PORTA,RA2
    movlw   0x20                            ;FULL (duty = 100%)
    btfss   PORTA,RA4
    movlw   0x10                            ;DIM (duty = 50%)
    andlw   0xFF
    btfsc   STATUS,Z
    goto    MAIN_SLEEP                      ;loop to sleep
WORK_DO
    clrwdt
    movwf   CCPR1L                          ;set duty
    movlw   (1<<TMR2ON)
    movwf   T2CON
    movlw   (1<<CCP1M3)|(1<<CCP1M2)
    movwf   CCP1CON                         ;run PWM module

;check power
PWR_CHECK
    bsf     PORTC,RC6                       ;PCHECK ON
    movlw   (1<<RB4)|(1<<RB7)               ;CTRL ON, TCHECK ON
    movwf   PORTB
    movlw   (1<<CHS2)|(1<<ADON)             ;AN4 result in ADRESH (LA)
    call    GET_ADC
    movlw   .110                            ;11.8V
    subwf   ADRESH,w
    btfss   STATUS,C
    bsf     FLAGS,BADPWR
    movlw   .140                            ;13.1V
    subwf   ADRESH,w
    btfss   STATUS,C
    bsf     FLAGS,LOWPWR
    btfsc   STATUS,C
    bcf     FLAGS,BADPWR
    movlw   .147                            ;14.2V
    subwf   ADRESH,w
    btfsc   STATUS,C
    bcf     FLAGS,LOWPWR
TEMP_CHECK
;check temp
    movlw   (1<<ADFM)|(1<<CHS3)|(1<<CHS0)|(1<<ADON) ;AN9 result RA
    call    GET_ADC
    bsf     STATUS,RP0                      ;set bank 1
    movlw   .93
    subwf   ADRESL,w
    btfsc   STATUS,C
    bsf     FLAGS,OVERT
    movlw   .81
    subwf   ADRESL,w
    btfss   STATUS,C
    bcf     FLAGS,OVERT
    bcf     STATUS,RP0                      ;set bank 0

SET_LEDS
    movlw   (1<<RC1)|(1<<RC4)|(1<<RC2)|(1<<RC6) ;G ON, HPWR ON, SH ON, PCHECK ON
    btfsc   FLAGS,LOWPWR
    movlw   (1<<RC3)|(1<<RC4)|(1<<RC2)|(1<<RC6) ;R ON, HPWR ON, SH ON, PCHECK ON
    movwf   TEMP
    clrw
    btfsc   FLAGS,OVERT
    iorlw   (1<<RC3)
    btfsc   FLAGS,BADPWR
    iorlw   (1<<RC1)
    btfss   TMR1H,6
    xorwf   TEMP,f                          ;G/R LED INV(blink)
    andlw   0xFF
    btfss   STATUS,Z
    bcf     TEMP,RC4                        ;SHDN
    movfw   TEMP
    movwf   PORTC
    goto    MAIN_ON
    END