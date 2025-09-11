                                final baseStyle = {
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                  ),
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                  ),
                                };

                                final commonStyle = baseStyle;

                                final truncatedStyle = {
                                  ...baseStyle,
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                    maxLines: maxLines,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                  "p": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    color: _getDescriptionColor(),
                                    fontSize: FontSize(11),
                                    lineHeight: LineHeight.number(1.3),
                                    letterSpacing: 0.2,
                                    maxLines: maxLines,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                };

                                final fullHtml = Html(
                                  data: widget.description!,
                                  style: commonStyle,
                                );

                                final truncatedHtml = Html(
                                  data: widget.description!,
                                  style: truncatedStyle,
                                );