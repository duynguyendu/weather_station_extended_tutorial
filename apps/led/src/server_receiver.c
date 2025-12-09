#include "token.h"
#include <kos.h>

kos_msg_server_t server = {0};

enum led_protocol {
  LED_PROTOCOL_TOKEN_REQUEST = 1,
  LED_PROTOCOL_ON,
  LED_PROTOCOL_OFF,
};

// Define a badge used to identify requests
// for access to 'led_protocol'
#define LED_PROTOCOL_REQUEST_BADGE (~0)

// void start_receive_server() {
//   // ------------ SETUP LED PROTOCOL SERVER
//   // Allocate a reply cap
//   kos_printf("Initializing message server for LED app\n");
//   kos_cap_t reply_cap = kos_cap_reserve();
//   if (config_set(CONFIG_KERNEL_MCS)) {
//     kos_assert_created(kos_cap_alloc_reply(reply_cap),
//     "kos_cap_alloc_reply");
//   }

//   // Set up the server instance.
//   kos_token_t server_token = 0;
//   kos_msg_token_slot_pool_alloc(&server_token);
//   // kos_assert_ok(kos_msg_token_slot_pool_alloc(&server_token),
//   //               "kos_msg_token_slot_pool_alloc server");
//   kos_printf("Token slot pool: %s\n", server_token);
//   kos_cap_t server_cap = kos_cap_reserve();
//   kos_assert_created(kos_msg_server_create(server_cap, reply_cap, 3,
//   &server),
//                      "kos_msg_server_create");

//   // Bind to our port
//   kos_assert_ok(kos_dir_bind("led_protocol", LED_PROTOCOL_TOKEN_REQUEST,
//                              LED_PROTOCOL_REQUEST_BADGE, 0),
//                 "kos_dir_bind");

//   kos_printf("Begin receiving message loop\n");
//   // Implement server loop.
//   while (true) {
//     kos_word_t badge;
//     kos_word_t caller_id;

//     kos_msg_t msg = kos_msg_new_status(STATUS_OK);
//     kos_assert_ok(kos_msg_reply_receive(&msg, &badge, &caller_id),
//                   "kos_msg_reply_receive");

//     // act on the label.
//     switch (msg.label) {
//     case LED_PROTOCOL_TOKEN_REQUEST:
//       // received a 'my_server_protocol' token request.
//       // create a token for the caller and pass it back.
//       kos_printf("Receving token request\n");
//       kos_assert_created(kos_msg_token_create(caller_id, 0, 4),
//                          "kos_msg_token_create");
//       msg = kos_msg_new(STATUS_OK, 0, 0, 4, 0);
//       break;
//     case LED_PROTOCOL_ON:
//       kos_printf("Receive turning ON message");
//       msg = kos_msg_new_status(STATUS_OK);
//       break;
//     case LED_PROTOCOL_OFF:
//       kos_printf("Receive turning OFF message");
//       msg = kos_msg_new_status(STATUS_OK);
//       break;
//     default:
//       // received an unknown call.
//       msg = kos_msg_new_status(STATUS_NOT_IMPLEMENTED);
//       break;
//     }
//   }
// }

void start_receive_server() {
  // Connect to the log port
  kos_status_t status;

  kos_cap_t rely_cap = kos_cap_reserve();
  kos_assert_created(kos_cap_alloc_reply(rely_cap), "kos_cap_alloc_reply");

  kos_cap_t server_cap = kos_cap_reserve();

  status = kos_msg_server_create(server_cap, rely_cap, TOKEN_SERVER, &server);
  kos_assert_created(status, "kos_msg_server_create");

  kos_assert_ok(kos_dir_bind("led_protocol", LED_PROTOCOL_TOKEN_REQUEST,
                             LED_PROTOCOL_REQUEST_BADGE, 0),
                "kos_dir_bind");

  kos_msg_t msg = kos_msg_new_status(STATUS_OK);

  kos_printf("Begin receiving message loop\n");
  while (true) {
    kos_word_t badge; // to differentiate between request
    kos_word_t caller_id;

    kos_assert_ok(kos_msg_reply_receive(&msg, &badge, &caller_id),
                  "kos_msg_reply_receive");

    kos_printf("Receive a message\n");
    if (badge == LED_PROTOCOL_REQUEST_BADGE) {
      kos_printf("Message request bade\n");
      status = kos_msg_token_create(caller_id, 0, TOKEN_SERVER_TRANSFER);
      kos_assert_created(status, "kos_msg_token_create");
      msg = kos_msg_new(STATUS_OK, 0, 0, TOKEN_SERVER_TRANSFER, 0);
      continue;
    }

    switch (msg.label) {
    case LED_PROTOCOL_ON:
      kos_printf("Receive turning ON message");
      msg = kos_msg_new_status(STATUS_OK);
      break;
    case LED_PROTOCOL_OFF:
      kos_printf("Receive turning OFF message");
      msg = kos_msg_new_status(STATUS_OK);
      break;
    default:
      msg = kos_msg_new_status(STATUS_NOT_IMPLEMENTED);
      break;
    }
  }
}
