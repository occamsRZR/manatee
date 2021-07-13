defmodule ManateeWeb.ApplicationLive.DateTimePickerComponent do
  use ManateeWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <!-- component -->
    <div
    x-data
    x-init="flatpickr($refs.datetimewidget, {wrap: true, enableTime: true, dateFormat: 'M j, Y h:i K'});"
    x-ref="datetimewidget"
    class="flatpickr container mx-auto col-span-6 sm:col-span-6 mt-5"
    >
    <div class="flex align-middle align-content-center">
      <input
          x-ref="datetime"
          type="text"
          id="datetime"
          data-input
          placeholder="Select.."
          autocomplete="off"
          name="application[applied_at]"
          class="block w-full px-2 border-gray-300 focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 rounded-l-md shadow-sm"
          value='<%= @f.data.applied_at |> Timex.format!("%b %d, %Y %l:%M %p", :strftime) %>'

      >

      <a
          class="h-11 w-10 input-button cursor-pointer rounded-r-md bg-transparent border-gray-300 border-t border-b border-r"
          title="clear" data-clear
      >
          <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 mt-2 ml-1" viewBox="0 0 20 20" fill="#c53030">
              <path fill-rule="evenodd"
                    d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                    clip-rule="evenodd"/>
          </svg>
      </a>

    </div>

    </div>
    """
  end
end
