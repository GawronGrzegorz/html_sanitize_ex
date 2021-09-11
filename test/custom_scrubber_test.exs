defmodule CustomScrubberTest do
  use ExUnit.Case, async: true

  defmodule Custom do
    use HtmlSanitizeEx.Scrubber

    remove_cdata_sections_before_scrub()

    strip_comments()

    allow_tag_with_any_attributes("p")

    strip_everything_not_covered()
  end

  defp scrub(text) do
    HtmlSanitizeEx.Scrubber.scrub(text, __MODULE__.Custom)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!<p class="allowed">hello code!</p>)
    assert expected == scrub(input)
  end
end
