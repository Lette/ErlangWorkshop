
-module(csv_parser).

-export([read_file/1]).

read_file(Path) ->
	{ok, IoDevice} = file:open(Path, [read]),
	{_, HeaderString} = file:read_line(IoDevice),
	Lines = read_all_lines(IoDevice, []),
	Headers = string:tokens(HeaderString, ",\n"),

	fill_result_rows(Headers, Lines, []).

fill_result_rows(Headers, [Line | Lines], Accum) ->
	Map = fill_result_columns(Headers, string:tokens(Line, ",\n"), #{}),
	fill_result_rows(Headers, Lines, [Map | Accum]);

fill_result_rows(_, [], Accum) ->
	Accum.

fill_result_columns([Header | Headers], [Column | Columns], Map) ->
	fill_result_columns(Headers, Columns, Map#{Header => Column});

fill_result_columns([], _, Map) ->
	Map.

read_all_lines(Device, List) ->
	case file:read_line(Device) of
		eof -> List;
		{ok, Line} -> read_all_lines(Device, [Line | List])
	end.