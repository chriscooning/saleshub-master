window.initInfiniteScroll = (url, total_count, container, data = {}) ->
  if total_count > 10
    page = 1
    is_fetching = false
    data ?= {}
    $(window).scroll ->
      if (1 + page * 9) < total_count and not is_fetching
        if $(window).scrollTop() + $(window).height() + 300 > $(document).height()
          $('.loading-more').removeClass('hidden')
          is_fetching = true
          data.page = page + 1
          $.ajax
            url: url
            data: data
            success: (data) ->
              is_fetching = false
              $('.loading-more').addClass('hidden')
              $data = $(data)
              $data.find('a.fancybox').fancybox();
              $(container).append($data)

              page += 1


window.initInfiniteScrollForNewsEntries = (url, total_count, container_map, data = {}) ->
  if total_count > 10
    page = 1
    is_fetching = false
    data ?= {}
    $(window).scroll ->
      if (1 + page * 9) < total_count and not is_fetching
        if $(window).scrollTop() + $(window).height() + 300 > $(document).height()
          $('.loading-more').removeClass('hidden')
          is_fetching = true
          data.page = page + 1
          $.ajax
            url: url
            data: data
            success: (data) ->
              is_fetching = false
              $('.loading-more').addClass('hidden')
              temp_container = $(document.createElement('div'))
              temp_container.append($(data))
              for entry in temp_container.children().toArray()
                entry = $(entry)
                type = entry.data('news-type')
                container_sel = container_map[type]
                if container_sel?
                  container = $(container_sel)
                  if container.size() < 1
                    throw new Error("container #{container_sel} is not existing")
                  $entry = $(entry)
                  $entry.find('a.fancybox').fancybox();
                  $(container).append($entry)
                else
                  throw new Error("unknown news type: #{type}")
              temp_container.remove()
              page += 1

