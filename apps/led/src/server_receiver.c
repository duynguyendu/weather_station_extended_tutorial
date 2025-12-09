#include <kos.h>

kos_msg_server_t server = {0};

enum led_protocol {
  LED_PROTOCOL_TOKEN_REQUEST = 1,
  LED_PROTOCOL_ON,
  LED_PROTOCOL_OFF,
};

// Define a badge used to identify requests
// for access to 'my_server_protocol'
#define LED_PROTOCOL_REQUEST_BADGE (~0)

void start_receive_server() {
  // ------------ SETUP LED PROTOCOL SERVER
  // Allocate a reply cap
  kos_cap_t reply_cap = kos_cap_reserve();
  if (config_set(CONFIG_KERNEL_MCS)) {
    kos_assert_created(kos_cap_alloc_reply(reply_cap), "kos_cap_alloc_reply");
  }

  // Set up the server instance.
  kos_token_t server_token;
  // kos_assert_ok(kos_msg_token_slot_pool_alloc(&server_token),
  //               "kos_msg_token_slot_pool_alloc server");
  kos_cap_t server_cap = kos_cap_reserve();
  kos_assert_created(
      kos_msg_server_create(server_cap, reply_cap, server_token, &server),
      "kos_msg_server_create");

  // Bind to our port
  kos_assert_ok(kos_dir_bind("my_server_protocol", LED_PROTOCOL_TOKEN_REQUEST,
                             LED_PROTOCOL_REQUEST_BADGE, 0),
                "kos_dir_bind");

  kos_token_t empty_token;
  // kos_assert_ok(kos_msg_token_slot_pool_alloc(&empty_token),
  //               "kos_msg_token_slot_pool_alloc empty");

  // Implement server loop.
  while (true) {
    kos_word_t badge;
    kos_word_t caller_id;

    kos_msg_t msg = kos_msg_new_status(STATUS_OK);
    kos_assert_ok(kos_msg_reply_receive(&msg, &badge, &caller_id),
                  "kos_msg_reply_receive");

    // act on the label.
    switch (msg.label) {
    case LED_PROTOCOL_TOKEN_REQUEST:
      // received a 'my_server_protocol' token request.
      // create a token for the caller and pass it back.
      kos_assert_created(kos_msg_token_create(caller_id, 0, empty_token),
                         "kos_msg_token_create");
      msg = kos_msg_new(STATUS_OK, 0, 0, empty_token, 0);
      break;
    case LED_PROTOCOL_ON:
      kos_printf("Receive turning ON message");
      msg = kos_msg_new_status(STATUS_OK);
      break;
    case LED_PROTOCOL_OFF:
      kos_printf("Receive turning OFF message");
      msg = kos_msg_new_status(STATUS_OK);
      break;
    default:
      // received an unknown call.
      msg = kos_msg_new_status(STATUS_NOT_IMPLEMENTED);
      break;
    }
  }
}
