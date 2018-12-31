module Message exposing (Message, MessageForm, encode, decode, decodeMessageList, niceDate)

import Json.Encode as E
import Json.Decode as D
import Time


type alias Message =
    { to : String
    , from : String
    , subject : String
    , body : String
    , timeSent : Time.Posix
    }


type alias MessageForm =
    { to : String
    , from : String
    , subject : String
    , body : String
    , expiration : Int
    }


messageFromForm : Time.Posix -> MessageForm -> Message
messageFromForm time messageForm =
    { to = messageForm.to
    , from = messageForm.from
    , subject = messageForm.subject
    , body = messageForm.body
    , timeSent = time
    }


encode : Time.Posix -> MessageForm -> E.Value
encode time messageForm =
    messageEncoder (messageFromForm time messageForm)


messageEncoder : Message -> E.Value
messageEncoder message =
    E.object
        [ ( "to", E.string message.to )
        , ( "from", E.string message.from )
        , ( "subject", E.string message.subject )
        , ( "body", E.string message.body )
        , ( "timeSent", E.int (Time.posixToMillis message.timeSent) )
        ]


decode : Time.Zone -> E.Value -> Result D.Error Message
decode zone value =
    D.decodeValue (messageDecoder zone) value


decodeMessageList : Time.Zone -> E.Value -> Result D.Error (List Message)
decodeMessageList zone value =
    D.decodeValue (messageListDecoder zone) value


messageListDecoder : Time.Zone -> D.Decoder (List Message)
messageListDecoder zone =
    D.list (messageDecoder zone)


messageDecoder : Time.Zone -> D.Decoder Message
messageDecoder zone =
    D.map5 Message
        (D.field "to" D.string)
        (D.field "from" D.string)
        (D.field "subject" D.string)
        (D.field "body" D.string)
        ((D.field "timeSent" D.int) |> D.map Time.millisToPosix)


niceDate : Time.Zone -> Time.Posix -> String
niceDate zone time =
    let
        second =
            Time.toSecond zone time |> padZero

        minute =
            Time.toMinute zone time |> padZero

        hour =
            Time.toHour zone time |> padZero

        day =
            Time.toDay zone time |> padZero

        month =
            monthString zone time

        year =
            Time.toYear zone time |> padZero
    in
        month ++ "-" ++ day ++ "-" ++ year ++ " " ++ hour ++ ":" ++ minute ++ ":" ++ second


monthString : Time.Zone -> Time.Posix -> String
monthString zone time =
    case Time.toMonth zone time of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"


padZero : Int -> String
padZero n =
    let
        str =
            String.fromInt n
    in
        case String.length str of
            0 ->
                "00"

            1 ->
                "0" ++ str

            _ ->
                str
