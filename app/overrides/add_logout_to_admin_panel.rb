Deface::Override.new(virtual_path: 'spree/admin/shared/_tabs',
                     name: 'add_logout_to_admin_panel',
                     insert_after: "erb[loud]:contains('users')",
                     text: "<li class='tab-with-icon'>
                              <%= link_to(main_app.destroy_user_session_path, method: :delete, class: 'fa fa-sign-out icon_link with-tip') do %>
                                <span class='text'>LOGOUT</span>
                              <% end %>
                            </li>")
