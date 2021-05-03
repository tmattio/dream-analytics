let render_top_page (s, i) = 
  <tr class="bg-white">
    <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
      <%s s %>
    </td>
    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
      <%i i %>
    </td>
  </tr>

let render_top_pages top_pages =
  String.concat "\n" @@ List.map render_top_page top_pages

let render (events : Event.t list) =
  let top_pages = Event.top_pages events in
  <div class="p-12 flex-1 min-w-0">
    <p class="text-sm font-medium text-gray-900">
      Top pages
    </p>
    <div class="mt-5 flex flex-col">
      <div class="-my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
        <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
          <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Page url
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Visitors
                  </th>
                </tr>
              </thead>
              <tbody>
                <%s! render_top_pages top_pages %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
