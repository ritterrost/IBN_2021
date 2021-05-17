import math

type address = uint64

const BUS_SIZE = 64
const PAGE_SIZE_BITS = 23
# const MAX_PAGE_INDEX = 2^(BUS_SIZE - PAGE_SIZE_BITS) - 1
const MAX_PAGE_INDEX = 8_388_608 # 1 MiB
const OFFSET_MASK =  address(2^PAGE_SIZE_BITS - 1)
const FRAME_INDEX_MASK = address(not(0u64) xor OFFSET_MASK)

var page_table: array[0..MAX_PAGE_INDEX, address]


proc set(page_index, frame_index: address, flags: address = 0) =
  ## Sets one entry of page_table
  let frame_index_shifted = (frame_index shl PAGE_SIZE_BITS) + flags
  page_table[page_index] = address(frame_index_shifted)

proc translate(virtual_adr: address): address =
  ## Translate virtual address to a physical address

  # Get offset and page index
  let offset = virtual_adr and OFFSET_MASK
  let page_index = virtual_adr shr PAGE_SIZE_BITS   # shr = shift right

  # Read from page_table
  let frame_index_shifted = page_table[page_index]

  # Compose physical address
  result = (frame_index_shifted and FRAME_INDEX_MASK) + offset


set(0, 10)
set(1, 20)
set(2, 0)

echo "Translates 10 to: ", translate(10)
echo "Translates 4096+10 to: ", translate(4096+10)
echo "Translates 2*4096+10 to: ", translate(2*4096+10)

